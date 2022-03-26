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
    
    @Published var groupName = ""
    @Published var sermonItem = CommunityGroupCardVM.GroupSermonItem()
    @Published var prayItem = CommunityGroupCardVM.GroupPrayItem()
    
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
        groupName = groupInfo.groupName
        service.fetchLatestSermon()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { data in
                UserData.shared.sermon = data
                self.sermonItem = GroupSermonItem(sermon: data)
            })
            .store(in: &cancellables)
    }
    
    func fetchLatestGroupPray() {
        service.fetchLatestGroupPray()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { data in
                self.prayItem = GroupPrayItem(groupMemberPrayList: data)
            })
            .store(in: &cancellables)
    }
}

extension CommunityGroupCardVM {
    struct GroupSermonItem {
        var meetingDate: String = ""
        var groupQuestion: [GroupQuestion] = []
        var totalQuestionCount = 0
        var answeredQuestionCount = 0
        
        init() {}
        
        init(sermon: Sermon) {
            self.meetingDate = sermon.date
            self.groupQuestion = sermon.groupQuestionList
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
    
    struct GroupPrayItem {
        var prayRegisterDate: String = ""
        var lastestPrayDate: String = ""
        var prayList: GroupMemberPrayList?
        
        init() {
        }
        
        init(groupMemberPrayList: GroupMemberPrayList) {
            prayRegisterDate = groupMemberPrayList.date
            prayList = groupMemberPrayList
        }
    }
}
