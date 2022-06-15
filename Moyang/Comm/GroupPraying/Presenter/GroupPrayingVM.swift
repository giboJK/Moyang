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
    var auth: String // 처음 진입 시 선택된 유저
    var email: String // 처음 진입 시 선택된 유저
    var members: [Member] = []
    
    let memberNameList = BehaviorRelay<[String]>(value: [])
    let selectedMemberName = BehaviorRelay<String>(value: "")
    let songName = BehaviorRelay<String?>(value: nil)
    let isPlaying = BehaviorRelay<Bool>(value: false)
    let memberPrayList = BehaviorRelay<[(member: Member, list: PrayList)]>(value: [])
    let prayList = BehaviorRelay<[PrayItem]>(value: [])
    let isPrevEnabled = BehaviorRelay<Bool>(value: false)
    let isNextEnabled = BehaviorRelay<Bool>(value: false)
    
    private var player: AVAudioPlayer?
    private var url: URL?
    
    init(useCase: CommunityMainUseCase,
         auth: String,
         email: String,
         groupID: String) {
        self.useCase = useCase
        self.groupID = groupID
        self.auth = auth
        self.email = email
        bind()
        setButtonEnabled()
        loadSong()
    }

    deinit { Log.i(self) }
    
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
    }
    
    private func setPrayList() {
        let list = memberPrayList.value
        var itemList = [PrayItem]()
        list.filter { $0.member.auth == self.auth && $0.member.email == self.email}.forEach { item in
            item.list.forEach { pray in
                itemList.append(PrayItem(memberID: item.member.id,
                                         memberAuth: self.auth,
                                         memberEmail: self.email,
                                         name: item.member.name,
                                         pray: pray.pray,
                                         date: pray.date,
                                         prayID: pray.id,
                                         tags: pray.tags))
            }
        }
        prayList.accept(itemList)
        if itemList.isEmpty {
            fetchPrayList()
        }
        
        if let item = memberPrayList.value.first(where: { $0.member.auth == self.auth &&
            $0.member.email == self.email
        }) {
            selectedMemberName.accept(item.member.name)
        }
    }
    
    private func setButtonEnabled() {
        if let index = members.firstIndex(where: { $0.auth == auth && $0.email == email }) {
            isNextEnabled.accept(members.count - 1 > index)
            isPrevEnabled.accept(0 < index)
        }
    }
    
    private func fetchPrayList(date: String = Date().toString("yyyy-MM-dd hh:mm:ss a")) {
        useCase.fetchMemberIndividualPray(memberAuth: auth, email: email, groupID: groupID, limit: 10, start: date)
    }
    
    
    func fetchMorePrayList() {
        if let date = prayList.value.last?.date {
            fetchPrayList(date: date)
        }
    }
    
    private func fetchNextMember() {
        if let index = members.firstIndex(where: { $0.auth == auth && $0.email == email }) {
            let cur = index + 1
            auth = members[min(members.count - 1, cur)].auth
            email = members[min(members.count - 1, cur)].email
            selectedMemberName.accept(members[min(members.count - 1, cur)].name)
            isNextEnabled.accept(members.count - 1 > cur)
            isPrevEnabled.accept(true)
            setPrayList()
        } else {
            Log.e("Failed to fetch data")
        }
    }
    
    private func fetchPrevMember() {
        if let index = members.firstIndex(where: { $0.auth == auth && $0.email == email }) {
            let cur = index - 1
            auth = members[max(0, cur)].auth
            email = members[max(0, cur)].email
            selectedMemberName.accept(members[max(0, cur)].name)
            isNextEnabled.accept(true)
            isPrevEnabled.accept(0 < cur)
            setPrayList()
        } else {
            Log.e("Failed to fetch data")
        }
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
    }
}

extension GroupPrayingVM {
    struct Input {
        var prevMemberPray: Driver<Void> = .empty()
        var nextMemberPray: Driver<Void> = .empty()
        var togglePlaySong: Driver<Void> = .empty()
    }

    struct Output {
        let memberList: Driver<[String]>
        let selectedMemberName: Driver<String>
        let songName: Driver<String?>
        let isPlaying: Driver<Bool>
        let prayList: Driver<[PrayItem]>
        let isPrevEnabled: Driver<Bool>
        let isNextEnabled: Driver<Bool>
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
        
        return Output(memberList: memberNameList.asDriver(),
                      selectedMemberName: selectedMemberName.asDriver(),
                      songName: songName.asDriver(),
                      isPlaying: isPlaying.asDriver(),
                      prayList: prayList.asDriver(),
                      isPrevEnabled: isPrevEnabled.asDriver(),
                      isNextEnabled: isNextEnabled.asDriver()
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
