//
//  GroupPrayingVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/19.
//

import SwiftUI
import Combine
import AVFoundation

class GroupPrayingVM: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    private let groupRepo: GroupRepo
    private let groupInfo: GroupInfo
    private var player: AVAudioPlayer?
    private var prayTimer: Timer?
    var time: Int = 0
    
    var contentList = [(id: String, title: String, pray:String)]()
    var memberList: [Member]?
    var dateItemList: [GroupPrayListVM.DateSortedItem]?
    var prayIndex = 0
    
    @Published var title: String = ""
    @Published var pray: String = ""
    @Published var timeString: String = "00:00:00"
    
    @Published var songName: String = "praysong"
    @Published var type: String = "m4a"
    @Published var isPlaying: Bool = false
    
    @Published var isAmenSaved: Bool = false
    @Published var isPrevPrayEnable: Bool = false
    @Published var isNextPrayEnable: Bool = false
    
    @Published var isLoading: Bool = false
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    init(groupRepo: GroupRepo, groupInfo: GroupInfo, title: String, pray: String, memberID: String, memberList: [Member] ) {
        self.groupRepo = groupRepo
        self.groupInfo = groupInfo
        self.title = title
        self.pray = pray
        self.memberList = memberList
        initPrayIndex(memberID: memberID, memberList: memberList)
        contentList.append((id: memberID, title: title, pray: pray))
        startSong()
    }
    
    init(groupRepo: GroupRepo,
         groupInfo: GroupInfo,
         title: String,
         pray: String,
         dateID: String,
         dateItemList: [GroupPrayListVM.DateSortedItem] ) {
        self.groupRepo = groupRepo
        self.groupInfo = groupInfo
        self.dateItemList = dateItemList
        initPrayIndex(date: dateID, dateItemList: dateItemList)
        contentList.append((id: dateID, title: title, pray: pray))
        startSong()
    }
    
    deinit {
        Log.i(self)
        UIApplication.shared.isIdleTimerDisabled = false
        stopSong()
        cancellables.removeAll()
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
    
    func togglePlaying() {
        if isPlaying {
            pauseSong()
        } else {
            playSong()
        }
    }
    
    func initPrayIndex(memberID: String, memberList: [Member]) {
        prayIndex = memberList.firstIndex(where: { $0.id == memberID }) ?? 0
        isNextPrayEnable = (prayIndex != max(0, memberList.count - 1))
        isPrevPrayEnable = (prayIndex != 0)
        Log.d("\(prayIndex) \(isNextPrayEnable) \(isPrevPrayEnable)")
    }
    
    func initPrayIndex(date: String, dateItemList: [GroupPrayListVM.DateSortedItem]) {
        prayIndex = dateItemList.firstIndex(where: { $0.date == date }) ?? 0
        isNextPrayEnable = (prayIndex != max(0, dateItemList.count - 1))
        isPrevPrayEnable = (prayIndex != 0)
        
        dateItemList.forEach { item in
            contentList.append(item.makeContents())
        }
        
        self.title = contentList[prayIndex].title
        self.pray = contentList[prayIndex].pray
        
        Log.d("\(prayIndex) \(isNextPrayEnable) \(isPrevPrayEnable)")
    }
    
    func nextPray() {
        if memberList != nil {
            nextMemberPray()
        } else {
            nextDatePray()
        }
    }
    
    private func nextMemberPray() {
        guard let memberList = memberList else {
            Log.e("memberList is empty")
            return
        }
        prayIndex = min(prayIndex + 1, max(0, memberList.count - 1))
        
        isNextPrayEnable = (prayIndex != max(0, memberList.count - 1))
        isPrevPrayEnable = (prayIndex != 0)
        
        fetchPray()
    }
    
    private func nextDatePray() {
        guard let dateList = dateItemList else {
            Log.e("dateList is empty")
            return
        }
        prayIndex = min(prayIndex + 1, max(0, dateList.count - 1))
        
        isNextPrayEnable = (prayIndex != max(0, dateList.count - 1))
        isPrevPrayEnable = (prayIndex != 0)
        
        fetchPray()
    }
    
    func prevPray() {
        if memberList != nil {
            prevMemberPray()
        } else {
            prevDatePray()
        }
    }
    
    private func prevMemberPray() {
        guard let memberList = memberList else {
            Log.e("memberList is empty")
            return
        }
        prayIndex = max(0, prayIndex - 1)
        
        isNextPrayEnable = (prayIndex != max(0, memberList.count - 1))
        isPrevPrayEnable = (prayIndex != 0)
        
        fetchPray()
    }
    
    private func prevDatePray() {
        guard let dateList = dateItemList else {
            Log.e("dateList is empty")
            return
        }
        prayIndex = max(0, prayIndex - 1)
        
        isNextPrayEnable = (prayIndex != max(0, dateList.count - 1))
        isPrevPrayEnable = (prayIndex != 0)
        
        fetchPray()
    }
    
    private func fetchPray() {
        if memberList != nil {
            fetchMemberPray()
        } else {
            fetchDatePray()
        }
    }
    
    private func fetchMemberPray() {
        guard let memberList = memberList else {
            Log.e("memberList is empty")
            return
        }
        isLoading = true
        if let index = contentList.firstIndex(where: { (id: String, _, _) in
            return id == memberList[prayIndex].id
        }) {
            isLoading = false
            title = contentList[index].title
            pray = contentList[index].pray
        } else {
            let member = memberList[prayIndex]
            groupRepo.fetchIndividualPrayList(member: member,
                                              groupID: groupInfo.id,
                                              limit: 20)
                .sink(receiveCompletion: { completion in
                    Log.i(completion)
                    self.isLoading = false
                }, receiveValue: { list in
                    var prayContents = ""
                    list.forEach { item in
                        prayContents.append(item.date)
                        prayContents.append("\n")
                        prayContents.append(item.pray)
                        prayContents.append("\n\n\n")
                    }
                    self.contentList.append((id: member.id, title: "\(member.name)의 기도", pray: prayContents))
                    self.changePray(title: "\(member.name)의 기도", pray: prayContents)
                })
                .store(in: &cancellables)
        }
    }
    
    private func changePray(title: String, pray: String) {
        self.title = title
        self.pray = pray
    }
    
    private func fetchDatePray() {
        guard let dateItemList = dateItemList else {
            Log.e("dateItemList is empty")
            return
        }
        isLoading = true
        if let index = contentList.firstIndex(where: { (id: String, _, _) in
            return id == dateItemList[prayIndex].date
        }) {
            isLoading = false
            title = contentList[index].title
            pray = contentList[index].pray
        } else {
            isLoading = false
            // TODO: Fetching more date item
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
        isAmenSaved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.shouldDismissView = true
        }
    }
}
