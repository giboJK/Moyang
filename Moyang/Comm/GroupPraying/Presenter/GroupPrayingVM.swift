//
//  GroupPrayingVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/05.
//

import RxSwift
import RxCocoa
import AVFoundation

class GroupPrayingVM: VMType {
    typealias MemberItem = GroupPrayVM.MemberItem
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: PrayUseCase
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let memberList = BehaviorRelay<[MemberItem]>(value: [])
    let selectedMemberName = BehaviorRelay<String>(value: "")
    let songName = BehaviorRelay<String?>(value: nil)
    let isPlaying = BehaviorRelay<Bool>(value: false)
    let prayList = BehaviorRelay<[GroupIndividualPray]>(value: [])

    var timer: Timer?
    var prayingTime: Int = 0
    let prayingTimeStr = BehaviorRelay<String>(value: "00:00")
    let amenSuccess = BehaviorRelay<Void>(value: ())
    let isAmenEnable = BehaviorRelay<Bool>(value: false)
    
    private let longPressIndex = BehaviorRelay<Int?>(value: nil)
    
    private var player: AVAudioPlayer?
    private var url: URL?
    private var userID = ""
    private var groupID = ""
    
    init(useCase: PrayUseCase, groupID: String?, userID: String? = nil) {
        self.useCase = useCase
        self.groupID = groupID ?? ""
        if let userID = userID {
            self.userID = userID
        } else {
            self.userID = UserData.shared.userInfo!.id
        }
        bind()
        loadSong()
        createTimer()
    }
    
    deinit {
        Log.i(self)
        timer?.invalidate()
        timer = nil
    }
    
    private func bind() {
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.userIDNameDict
            .subscribe(onNext: { [weak self] dict in
                self?.setMemberList(dict: dict)
            }).disposed(by: disposeBag)
        
//        useCase.memberPrayList
//            .subscribe(onNext: { [weak self] list in
//                self?.memberPrayList.accept(list)
//                self?.setPrayList()
//            })
//            .disposed(by: disposeBag)
        
        useCase.songName
            .map { ($0 ?? "") + "                      " }
            .bind(to: songName)
            .disposed(by: disposeBag)
        
        useCase.songURL
            .subscribe(onNext: { [weak self] url in
                guard let url = url else { return }
                self?.playSong(songURL: url)
                self?.isPlaying.accept(true)
            }).disposed(by: disposeBag)
        
        useCase.amenSuccess
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.amenSuccess.accept(())
                self?.stopSong()
            }).disposed(by: disposeBag)
    }
    
    private func setMemberList(dict: [String: String]) {
        var list = dict.map { MemberItem(id: $0.key, name: $0.value) }
        list = list.sorted(by: { $0.name < $1.name })
        var allItem = MemberItem(id: "", name: "모두")
        allItem.isChecked = true
        list.append(allItem)
        memberList.accept(list)
        if let user = list.first(where: { item in
            item.id == userID
        }) {
            selectedMemberName.accept(user.name)

        }
    }
    private func setPrayList() {
        
    }
    
    private func loadSong() {
        useCase.loadSong()
    }
    
    private func toggleIsPlaying() {
        let current = isPlaying.value
        if current {
            stopSong()
        } else {
            if let url = url {
                playSong(songURL: url)
            }
        }
        isPlaying.accept(!current)
    }
    
    // music
    func playSong(songURL: URL) {
        url = songURL
        do {
            player = try AVAudioPlayer(contentsOf: songURL)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            player.numberOfLoops = -1
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch let error as NSError {
            Log.e(error.description)
        }
    }
    
    func stopSong() {
        player?.stop()
        player = nil
        timer?.invalidate()
        timer = nil
    }
    
    private func amen() {
        useCase.addAmen(groupID: groupID, time: prayingTime)
    }
    
    private func createTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
            timer?.tolerance = 0.1
        }
    }
    
    @objc func updateTimer() {
        prayingTime += 1
        let hour: Int = prayingTime / 3600
        let min: Int = (prayingTime - hour * 3600) / 60
        let sec: Int = prayingTime % 60
        if hour > 0 {
            prayingTimeStr.accept("\(String(format: "%02d", hour)):\(String(format: "%02d", min)):\(String(format: "%02d", sec))")
        } else {
            prayingTimeStr.accept("\(String(format: "%02d", min)):\(String(format: "%02d", sec))")
        }
        if !isAmenEnable.value {
            isAmenEnable.accept(prayingTime >= 10)
        }
    }
}

extension GroupPrayingVM {
    struct Input {
        var togglePlaySong: Driver<Void> = .empty()
        var didLongPressPray: Driver<Int?> = .empty()
        var amen: Driver<Void> = .empty()
    }
    
    struct Output {
        let selectedMemberName: Driver<String>
        let songName: Driver<String?>
        let isPlaying: Driver<Bool>
        let prayList: Driver<[GroupIndividualPray]>
        let prayingTimeStr: Driver<String>
        let amenSuccess: Driver<Void>
        let isAmenEnable: Driver<Bool>
        let longPressIndex: Driver<Int?>
    }
    
    func transform(input: Input) -> Output {
        input.togglePlaySong
            .drive(onNext: { [weak self] _ in
                self?.toggleIsPlaying()
            }).disposed(by: disposeBag)
        
        input.didLongPressPray
            .drive(onNext: { [weak self] index in
                guard let index = index else { return }
                self?.longPressIndex.accept(index)
            }).disposed(by: disposeBag)
        
        input.amen
            .drive(onNext: { [weak self] _ in
                self?.amen()
            }).disposed(by: disposeBag)
        
        return Output(selectedMemberName: selectedMemberName.asDriver(),
                      songName: songName.asDriver(),
                      isPlaying: isPlaying.asDriver(),
                      prayList: prayList.asDriver(),
                      prayingTimeStr: prayingTimeStr.asDriver(),
                      amenSuccess: amenSuccess.asDriver(),
                      isAmenEnable: isAmenEnable.asDriver(),
                      
                      longPressIndex: longPressIndex.asDriver()
        )
    }
    
    struct PrayingItem {
        let id: String
        let memberID: String
        let memberName: String
        let groupID: String
        let date: String
        let pray: String
        let tags: [String]
    }
}
