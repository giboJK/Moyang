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
    @Published var cellCardVM: CellCardVM?
    
    init(repo: DailyRepo) {
        self.repo = repo
        addDailyPreview()
        //        fetchDailyPreview()
    }
    
    func fetchDailyPreview() {
        repo.addDailyPreviewListener()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { dailyPreview in
                let item = DailyPreviewItem(data: dailyPreview)
                self.makeCellCardVM(cellCardItem: item.cellCardItem)
                self.makePrayCardVM(prayCardItem: item.prayCardItem)
            })
            .store(in: &cancellables)
    }
    
    func addDailyPreview() {
        let members = [GroupMember(id: "sadjoqwd",
                                   name: "김민준",
                                   profileURL: "http://"),
                       GroupMember(id: "sadjoq2wd",
                                   name: "김한결",
                                   profileURL: "http://"),
                       GroupMember(id: "sadjdoqwd",
                                   name: "김지형",
                                   profileURL: "http://"),
                       GroupMember(id: "sadjcoqwd",
                                   name: "박승호",
                                   profileURL: "http://"),
                       GroupMember(id: "s1adjoqwd",
                                   name: "장예람",
                                   profileURL: "http://"),
                       GroupMember(id: "sadewjoqwd",
                                   name: "김연재",
                                   profileURL: "http://"),
                       GroupMember(id: "sadj32tefoqwd",
                                   name: "황보예원",
                                   profileURL: "http://")]
        
        let data = DailyPreview(groupId: "qwlkdmlkwdm",
                                groupName: "고등부 3-1",
                                groupTalkingSubject: "몰라 알려주어잉",
                                groupMeetingDate: "2022-01-09",
                                groupMemberList: members,
                                qtId: "ddqwdw3e",
                                qtName: "qwdwqwidqiw1as",
                                qtSubject: "큐티는 뭘하나요",
                                prayId: "dmqomqi",
                                prayType: PrayType.my.rawValue,
                                praySubject: "주여 집중과 몰입",
                                prayIsAlarmOn: false,
                                prayAlarmTime: "21:00:00 am",
                                prayCreatedTimestamp: "2022-01-01",
                                prayDayList: ["mon", "thu", "sat"],
                                prayTime: PrayTime.five.code)
        
        repo.addDailyPreview(data)
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { isSaved in
                Log.d(isSaved)
            })
            .store(in: &cancellables)
    }
    
    private func makeCellCardVM(cellCardItem: CellCardItem) {
        let cellPreview = GroupPreview(name: cellCardItem.cellName,
                                       talkingSubject: cellCardItem.talkingSubject,
                                       dateString: cellCardItem.groupMeetingDate,
                                       memberList: cellCardItem.groupMemberList)
        cellCardVM = CellCardVM.init(cellPreview: cellPreview)
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
        let cellCardItem: CellCardItem
        let prayCardItem: PrayCardItem
        let qtItem: QTItem
        
        init(data: DailyPreview) {
            cellCardItem = CellCardItem(data: data)
            prayCardItem = PrayCardItem(data: data)
            qtItem = QTItem(data: data)
        }
    }
    
    struct CellCardItem {
        let cellName: String
        let talkingSubject: String
        let groupMeetingDate: String
        let groupMemberList: [GroupMember]
        
        init(data: DailyPreview) {
            cellName = data.groupName
            talkingSubject = data.groupTalkingSubject
            groupMeetingDate = data.groupMeetingDate
            
            var list = [GroupMember]()
            if let json = try? JSONSerialization.data(withJSONObject: data.groupMemberList) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let decodedList = try? decoder.decode([GroupMember].self, from: json) {
                    list = decodedList
                }
            }
            groupMemberList = list
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
