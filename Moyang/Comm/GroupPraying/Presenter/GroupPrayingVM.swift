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
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    let groupID: String
    var members: [Member] = []
    
    let memberList = BehaviorRelay<[String]>(value: [])
    let songName = BehaviorRelay<String?>(value: nil)
    let isPlaying = BehaviorRelay<Bool>(value: false)
    
    private var player: AVAudioPlayer?
    private var url: URL?
    
    init(useCase: CommunityMainUseCase, groupID: String) {
        self.useCase = useCase
        self.groupID = groupID
        bind()
        fetchPray()
        loadSong()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.memberList
            .subscribe(onNext: { [weak self] list in
                self?.members = list
                self?.memberList.accept(list.map { $0.name }.sorted(by: <))
            }).disposed(by: disposeBag)
        
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
    
    private func fetchPray() {
        
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
        let songName: Driver<String?>
        let isPlaying: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        input.togglePlaySong
            .drive(onNext: { [weak self] _ in
                self?.toggleIsPlaying()
            }).disposed(by: disposeBag)
        
        return Output(memberList: memberList.asDriver(),
                      songName: songName.asDriver(),
                      isPlaying: isPlaying.asDriver())
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
