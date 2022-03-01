//
//  CommunityCardListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/12.
//

import SwiftUI
import Combine

class CommunityCardListVM: ObservableObject {
    private let service: SermonRepo & GroupRepo = CommunityListService()
    private var cancellables: Set<AnyCancellable> = []
    
    private var groupInfo: GroupInfo?
    
    @Published var communityGroupCardVM = CommunityGroupCardVM()
    @Published var communityPrayCardVM = CommunityPrayCardVM()
    @Published var hasGroup: Bool = false
    
    init() {
    }
    
    func fetchCommunityData() {
        service.fetchGroupInfo()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { data in
                self.groupInfo = data
                UserData.shared.groupInfo = data
                self.fetchLastSermon()
            })
            .store(in: &cancellables)
    }
    
    func fetchLastSermon() {
        service.fetchLatestSermon()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { data in
                Log.w(data)
            })
            .store(in: &cancellables)
    }
    
    private func makeCellCardVM(item: GroupCardItem) {
    }
    
    private func makePrayCardVM(prayCardItem: PrayCardItem) {
    }
}

extension CommunityCardListVM {
    struct GroupCardItem {
        let cellName: String
        let talkingSubject: String
        let groupMeetingDate: String
        let groupMemberList: [Member]
        
        init(data: GroupMemberPray) {
            cellName = ""
            talkingSubject = ""
            groupMeetingDate = ""
            groupMemberList = []
        }
    }
    
    struct PrayCardItem: Identifiable {
        let id: String
        let prayType: String
        let praySubject: String
        let createdTimestamp: String
        let prayIsAlarmOn: Bool
        let prayAlarmTime: String
        let prayDayList: [String]
        let prayTime: String
        
        init(data: GroupMemberPray) {
            id = ""
            prayType = "data.prayTime"
            praySubject = ""
            createdTimestamp = ""
            prayIsAlarmOn = false
            prayAlarmTime = ""
            prayDayList = []
            prayTime = ""
        }
    }
}
