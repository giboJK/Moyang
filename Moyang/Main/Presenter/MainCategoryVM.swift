//
//  MainCategoryVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/12.
//

import SwiftUI
import Combine

class MainCategoryVM: ObservableObject {
    private let repo: SummaryRepo
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var prayCardVM: PrayCardVM?
    @Published var cellCardVM: CellCardVM?
    
    init(repo: SummaryRepo) {
        self.repo = repo
    }
    
    func fetchSummary() {
        repo.addSummaryListener()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { summary in
                let summaryItem = SummaryItem(summary: summary)
                self.makeCellCardVM(cellCardItem: summaryItem.cellCardItem)
                self.makePrayCardVM(prayCardItem: summaryItem.prayCardItem)
            })
            .store(in: &cancellables)
        
    }
    
    private func makeCellCardVM(cellCardItem: CellCardItem) {
        let cellPreview = CellPreview(cellName: cellCardItem.cellName,
                                      talkingSubject: cellCardItem.talkingSubject,
                                      dateString: cellCardItem.cellMeetingDate,
                                      memberList: cellCardItem.cellMemberList)
        cellCardVM = CellCardVM.init(cellPreview: cellPreview)
    }
    
    private func makePrayCardVM(prayCardItem: PrayCardItem) {
        let pray = Pray(id: prayCardItem.id,
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
    struct SummaryItem {
        let cellCardItem: CellCardItem
        let prayCardItem: PrayCardItem
        let qtItem: QTItem
        
        init(summary: Summary) {
            cellCardItem = CellCardItem(summary: summary)
            prayCardItem = PrayCardItem(summary: summary)
            qtItem = QTItem(summary: summary)
        }
    }
    
    struct CellCardItem {
        let cellName: String
        let talkingSubject: String
        let cellMeetingDate: String
        let cellMemberList: [CellMember]
        
        init(summary: Summary) {
            cellName = summary.cellName
            talkingSubject = summary.cellTalkingSubject
            cellMeetingDate = summary.cellMeetingDate
            
            var list = [CellMember]()
            if let json = try? JSONSerialization.data(withJSONObject: summary.cellMemberList) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let decodedList = try? decoder.decode([CellMember].self, from: json) {
                    list = decodedList
                }
            }
            cellMemberList = list
        }
    }
    
    struct PrayCardItem: Identifiable {
        let id: String
        let praySubject: String
        let createdTimestamp: String
        let prayIsAlarmOn: Bool
        let prayAlarmTime: String
        let prayDayList: [String]
        let prayTime: String
        
        init(summary: Summary) {
            id = summary.prayId
            praySubject = summary.praySubject
            createdTimestamp = summary.prayCreatedTimestamp
            prayIsAlarmOn = summary.prayIsAlarmOn
            prayAlarmTime = summary.prayAlarmTime
            prayDayList = summary.prayDayList
            prayTime = summary.prayTime
        }
    }
    
    struct QTItem: Identifiable {
        let id: String
        let qtName: String
        let qtSubject: String
        
        init(summary: Summary) {
            id = "summary.qtId"
            qtName = "summary.qtName"
            qtSubject = "summary.qtSubject"
        }
    }
}
