//
//  CommunityGroupCardVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import Combine

class CommunityGroupCardVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let service: SermonRepo & GroupRepo = CommunityListService()
    
    @Published var item = CommunityGroupCardVM.GroupMeetingItem()
    
    init() {
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func fetchLastSermon() {
        guard let groupInfo = UserData.shared.groupInfo else {
            return
        }
        service.fetchLatestSermon()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { data in
                Log.w(data)
                self.item = GroupMeetingItem(groupName: groupInfo.groupName, sermon: data)
            })
            .store(in: &cancellables)
    }
    
    func fetchLatestGroupPray() {
        service.fetchLatestGroupPray()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { data in
                Log.w(data)
            })
            .store(in: &cancellables)
    }
}

extension CommunityGroupCardVM {
    struct GroupMeetingItem {
        var groupName: String
        var meetingDate: String
        var groupQuestion: [GroupQuestion]
        var prayRegisterDate: String
        var lastestPrayDate: String
        var prayList: GroupMemberPrayList?
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
        
        init(groupName: String, sermon: Sermon) {
            self.groupName = groupName
            self.meetingDate = sermon.date
            self.groupQuestion = sermon.groupQuestionList
            self.prayRegisterDate = ""
            self.lastestPrayDate = ""
            self.prayList = nil
            self.totalQuestionCount = groupQuestion.count
            var answered = 0
            groupQuestion.forEach { groupQuestion in
                if groupQuestion.question.isAnswered {
                    answered += 1
                }
            }
            self.answeredQuestionCount = answered
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
