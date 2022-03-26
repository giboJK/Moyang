//
//  GroupPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/19.
//

import SwiftUI
import Combine
import AVFoundation

class GroupPrayVM: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    private var player: AVAudioPlayer?
    private var prayTimer: Timer?
    var time: Int = 0
    
    @Published var title: String = ""
    @Published var pray: String = "praysong"
    @Published var timeString: String = "00:00:00"
    
    @Published var songName: String = "praysong"
    @Published var type: String = "m4a"
    @Published var isPlaying: Bool = false
    
    init(title: String, pray: String) {
        self.title = title
        self.pray = pray
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
    
    deinit {
        Log.i(self)
        UIApplication.shared.isIdleTimerDisabled = false
        stopSong()
        cancellables.removeAll()
    }
    
    func togglePlaying() {
        if isPlaying {
            pauseSong()
        } else {
            playSong()
        }
    }
    
    func nextSong() {
        
    }
    
    func prevSong() {
        
    }
    
    func playSong() {
        if let url = Bundle.main.url(forResource: songName, withExtension: type) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1
                player?.play()
                isPlaying = true
                prayTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                 target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            } catch {
                print("ERROR")
            }
        }
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
    
    func pauseSong() {
        isPlaying = false
        prayTimer?.invalidate()
        player?.pause()
    }
    
    func stopSong() {
        isPlaying = false
        prayTimer?.invalidate()
        player?.pause()
        player = nil
    }
    
    func amen() {
        
    }
}
