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
    typealias PrayList = [GroupIndividualPray]
    typealias PrayItem = GroupPrayListVM.PrayItem
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    let groupID: String
    var members: [Member] = []
    
    private let memberNameList = BehaviorRelay<[String]>(value: [])
    private let selectedMemberName = BehaviorRelay<String>(value: "")
    private let songName = BehaviorRelay<String?>(value: nil)
    private let isPlaying = BehaviorRelay<Bool>(value: false)
    private let memberPrayList = BehaviorRelay<[(member: Member, list: PrayList)]>(value: [])
    private let prayList = BehaviorRelay<[PrayItem]>(value: [])
    private let isPrevEnabled = BehaviorRelay<Bool>(value: false)
    private let isNextEnabled = BehaviorRelay<Bool>(value: false)

    private var timer: Timer?
    private var prayingTime: Int = 0
    private let prayingTimeStr = BehaviorRelay<String>(value: "00:00")
    private let amenSuccess = BehaviorRelay<Void>(value: ())
    private let isAmenEnable = BehaviorRelay<Bool>(value: false)
    
    private let longPressIndex = BehaviorRelay<Int?>(value: nil)
    
    private var player: AVAudioPlayer?
    private var url: URL?
    
    init(useCase: CommunityMainUseCase,
         groupID: String) {
        self.useCase = useCase
        self.groupID = groupID
        bind()
        setButtonEnabled()
        loadSong()
        createTimer()
    }
    
    deinit {
        Log.i(self)
        timer?.invalidate()
        timer = nil
    }
    
    private func bind() {
        useCase.memberList
            .subscribe(onNext: { [weak self] list in
                self?.members = list
                self?.memberNameList.accept(list.map { $0.name }.sorted(by: <))
            }).disposed(by: disposeBag)
        
        useCase.memberPrayList
            .subscribe(onNext: { [weak self] list in
                self?.memberPrayList.accept(list)
                self?.setPrayList()
            })
            .disposed(by: disposeBag)
        
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
            .bind(to: amenSuccess)
            .disposed(by: disposeBag)
    }
    
    private func setPrayList() {
//        list.filter { $0.member.auth == self.auth && $0.member.email == self.email }
//            .forEach { item in
//            item.list.forEach { pray in
//                if pray.isSecret {
//                    if self.auth != myInfo.authType || self.email != myInfo.email {
//                        return
//                    }
//                }
//                itemList.append(PrayItem(memberID: item.member.id,
//                                         name: item.member.name,
//                                         pray: pray.pray,
//                                         date: pray.date,
//                                         prayID: pray.id,
//                                         tags: pray.tags,
//                                         isSecret: pray.isSecret,
//                                         latestDate: pray.late
//                                         createDate: pray.registeredDate
//                                        ))
//            }
//        }
//        prayList.accept(itemList)
//        if itemList.isEmpty {
//            fetchPrayList()
//        }
//
//        if let item = memberPrayList.value.first(where: { $0.member.auth == self.auth &&
//            $0.member.email == self.email
//        }) {
//            selectedMemberName.accept(item.member.name)
//        }
    }
    
    private func setButtonEnabled() {
    }
    
    private func fetchPrayList(date: String = Date().toString("yyyy-MM-dd hh:mm:ss a")) {
        useCase.fetchMemberIndividualPray(memberAuth: "", email: "", groupID: groupID, limit: 10, start: date)
    }
    
    
    func fetchMorePrayList() {
//        if let date = prayList.value.last?.date {
//            fetchPrayList(date: date)
//        }
    }
    
    private func fetchNextMember() {
    }
    
    private func fetchPrevMember() {
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
        useCase.amen(time: prayingTime, groupID: groupID)
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
        var prevMemberPray: Driver<Void> = .empty()
        var nextMemberPray: Driver<Void> = .empty()
        var togglePlaySong: Driver<Void> = .empty()
        var didLongPressPray: Driver<Int?> = .empty()
        var amen: Driver<Void> = .empty()
    }
    
    struct Output {
        let memberList: Driver<[String]>
        let selectedMemberName: Driver<String>
        let songName: Driver<String?>
        let isPlaying: Driver<Bool>
        let prayList: Driver<[PrayItem]>
        let isPrevEnabled: Driver<Bool>
        let isNextEnabled: Driver<Bool>
        let prayingTimeStr: Driver<String>
        let amenSuccess: Driver<Void>
        let isAmenEnable: Driver<Bool>
        let longPressIndex: Driver<Int?>
    }
    
    func transform(input: Input) -> Output {
        input.prevMemberPray
            .drive(onNext: { [weak self] in
                self?.fetchPrevMember()
            }).disposed(by: disposeBag)
        
        input.nextMemberPray
            .drive(onNext: { [weak self] in
                self?.fetchNextMember()
            }).disposed(by: disposeBag)
        
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
        
        return Output(memberList: memberNameList.asDriver(),
                      selectedMemberName: selectedMemberName.asDriver(),
                      songName: songName.asDriver(),
                      isPlaying: isPlaying.asDriver(),
                      prayList: prayList.asDriver(),
                      isPrevEnabled: isPrevEnabled.asDriver(),
                      isNextEnabled: isNextEnabled.asDriver(),
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
