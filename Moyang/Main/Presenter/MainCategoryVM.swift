//
//  MainCategoryVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/12.
//

import SwiftUI
import Combine

class MainCategoryVM: ObservableObject {
    private let repo: DailyRepo
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var prayCardVM: PrayCardVM?
    @Published var groupCardVM: GroupCardVM?
    
    init(repo: DailyRepo) {
        self.repo = repo
        fetchDailyPreview()
    }
    
    func fetchDailyPreview() {
        repo.addDailyPreviewListener()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { dailyPreview in
                let item = DailyPreviewItem(data: dailyPreview)
                self.makeCellCardVM(item: item.groupCardItem)
                self.makePrayCardVM(prayCardItem: item.prayCardItem)
            })
            .store(in: &cancellables)
    }
    
    private func makeCellCardVM(item: GroupCardItem) {
        let preview = GroupPreview(name: item.cellName,
                                   talkingSubject: item.talkingSubject,
                                   dateString: item.groupMeetingDate,
                                   memberList: item.groupMemberList)
        groupCardVM = GroupCardVM.init(preview: preview)
    }
    
    private func makePrayCardVM(prayCardItem: PrayCardItem) {
        let pray = Pray(id: prayCardItem.id,
                        type: prayCardItem.prayType,
                        createdTimestamp: prayCardItem.createdTimestamp,
                        praySubject: prayCardItem.praySubject,
                        isAlarmOn: prayCardItem.prayIsAlarmOn,
                        prayAlarmTime: prayCardItem.prayAlarmTime,
                        prayDayList: prayCardItem.prayDayList,
                        prayTime: prayCardItem.prayTime)
        prayCardVM = PrayCardVM.init(pray: pray)
    }
}

extension MainCategoryVM {
    struct DailyPreviewItem {
        let groupCardItem: GroupCardItem
        let prayCardItem: PrayCardItem
        let qtItem: QTItem
        
        init(data: DailyPreview) {
            groupCardItem = GroupCardItem(data: data)
            prayCardItem = PrayCardItem(data: data)
            qtItem = QTItem(data: data)
        }
    }
    
    struct GroupCardItem {
        let cellName: String
        let talkingSubject: String
        let groupMeetingDate: String
        let groupMemberList: [GroupMember]
        
        init(data: DailyPreview) {
            cellName = data.groupName
            talkingSubject = data.groupTalkingSubject
            groupMeetingDate = data.groupMeetingDate
            groupMemberList = data.groupMemberList
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
        
        init(data: DailyPreview) {
            id = data.prayId
            prayType = data.prayTime
            praySubject = data.praySubject
            createdTimestamp = data.prayCreatedTimestamp
            prayIsAlarmOn = data.prayIsAlarmOn
            prayAlarmTime = data.prayAlarmTime
            prayDayList = data.prayDayList
            prayTime = data.prayTime
        }
    }
    
    struct QTItem: Identifiable {
        let id: String
        let qtName: String
        let qtSubject: String
        
        init(data: DailyPreview) {
            id = "data.qtId"
            qtName = "data.qtName"
            qtSubject = "data.qtSubject"
        }
    }
}
