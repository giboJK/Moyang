//
//  GroupPrayingVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/19.
//

import RxSwift
import RxCocoa
import AVFoundation

class GroupPrayingVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    private let groupRepo: GroupRepo
    private let groupInfo: GroupInfo
    private var title: String
    private var pray: String
    private var memberID: String = ""
    private var memberList: [Member]
    
    private var player: AVAudioPlayer?
    private var prayTimer: Timer?
    var timeString: String = "00:00:00"
    var time: Int = 0
    var songName: String = "praysong"
    var type: String = "m4a"
    
    let isPlaying = BehaviorRelay<Bool>(value: false)
    
    init(groupRepo: GroupRepo, groupInfo: GroupInfo, title: String, pray: String, memberID: String, memberList: [Member]) {
        self.groupRepo = groupRepo
        self.groupInfo = groupInfo
        self.title = title
        self.pray = pray
        self.memberList = memberList
        bind()
        startSong()
    }

    deinit {
        Log.i(self)
        UIApplication.shared.isIdleTimerDisabled = false
        stopSong()
    }
    
    private func bind() {
    }
    
    private func startSong() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSong()
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
            Log.e("error")
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func stopSong() {
        isPlaying.accept(false)
        prayTimer?.invalidate()
        player?.pause()
        player = nil
    }
    
    func playSong() {
        if let url = Bundle.main.url(forResource: songName, withExtension: type) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1
                player?.play()
                isPlaying.accept(true)
                prayTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                 target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            } catch {
                print("ERROR")
            }
        }
    }
    
    func pauseSong() {
        isPlaying.accept(false)
        prayTimer?.invalidate()
        player?.pause()
    }
    
    @objc func updateTimer() {
        time += 1
        let timeStr = secondsToHoursMinutesSeconds(time)
        let hour = String(format: "%02d", timeStr.hour)
        let min = String(format: "%02d", timeStr.min)
        let sec = String(format: "%02d", timeStr.sec)
        timeString = "\(hour):\(min):\(sec)"
    }
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (hour: Int, min: Int, sec: Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

extension GroupPrayingVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
