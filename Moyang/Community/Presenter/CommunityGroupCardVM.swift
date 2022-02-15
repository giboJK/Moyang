//
//  CommunityGroupCardVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import Combine

class CommunityGroupCardVM: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    
    @Published var item = CommunityGroupCardVM.GroupMeetingItem()
    
    init() {
        fetchGroupItem()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func fetchGroupItem() {
        
    }
}

extension CommunityGroupCardVM {
    struct GroupMeetingItem {
        let groupName: String
        let meetingDate: String
        let groupQuestion: [GroupQuestion]
        let prayRegisterDate: String
        let lastestPrayDate: String
        let prayList: GroupMemberPrayList?
        var totalQuestionCount = 0
        var answeredQuestionCount = 0
        
        init() {
            groupName = ""
            meetingDate = ""
            groupQuestion = []
            prayRegisterDate = ""
            lastestPrayDate = ""
            prayList = nil
        }
        
        init(groupName: String,
             meetingDate: String,
             groupQuestion: [GroupQuestion],
             prayRegisterDate: String,
             lastestPrayDate: String,
             prayList: GroupMemberPrayList?
        ) {
            self.groupName = groupName
            self.meetingDate = meetingDate
            self.groupQuestion = groupQuestion
            self.prayRegisterDate = prayRegisterDate
            self.lastestPrayDate = lastestPrayDate
            self.prayList = prayList
            self.totalQuestionCount = groupQuestion.count
            var answered = 0
            groupQuestion.forEach { groupQuestion in
                if groupQuestion.question.isAnswered {
                    answered += 1
                }
            }
            self.answeredQuestionCount = answered
            
        }
    }
}
