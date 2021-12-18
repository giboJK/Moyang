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
        repo.fetchSummary()
            .map { summary in
                SummaryItem(summary: summary)
            }
            .sink { completion in
                Log.i(completion)
            } receiveValue: { item in
                let prayCardItem = item.prayCardItem
                let praySubject = PraySubject(id: prayCardItem.id,
                                              subject: prayCardItem.praySubject,
                                              timeString: prayCardItem.prayStartDate)
                self.prayCardVM = PrayCardVM.init(pray: praySubject)
                
                let cellCardItem = item.cellCardItem
                let cellPreview = CellPreview(cellName: cellCardItem.cellName,
                                              talkingSubject: cellCardItem.talkingSubject,
                                              dateString: cellCardItem.cellMeetingDate,
                                              memberList: cellCardItem.cellMemberList)
                self.cellCardVM = CellCardVM.init(cellPreview: cellPreview)
            }.store(in: &cancellables)
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
            cellMemberList = summary.cellMemberList
        }
    }
    
    struct PrayCardItem: Identifiable {
        let id: String
        let praySubject: String
        let prayStartDate: String
        
        init(summary: Summary) {
            id = summary.prayId
            praySubject = summary.praySubject
            prayStartDate = summary.prayStartDate
        }
    }
    
    struct QTItem: Identifiable {
        let id: String
        let qtName: String
        let qtSubject: String
        
        init(summary: Summary) {
            id = summary.qtId
            qtName = summary.qtName
            qtSubject = summary.qtSubject
        }
    }
}
