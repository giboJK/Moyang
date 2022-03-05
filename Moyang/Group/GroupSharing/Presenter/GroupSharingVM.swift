//
//  GroupSharingVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/21.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class GroupSharingVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var groupInfo: GroupInfo?
    
    private var repo: GroupRepo
    
    @Published var answerList: [String] = Array(repeating: "", count: 10)
    @Published var groupInfoItem: GroupInfoItem = GroupInfoItem()
    
    init(repo: GroupRepo) {
        self.repo = repo
        groupInfoItem = GroupInfoItem()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}

extension GroupSharingVM {
    typealias Identifier = Int
    struct GroupInfoItem {
        var groupName: String
        let talkingSubject: String
        var groupQuestionList: [GroupQuestion]
        let meetingDate: String
        
        init() {
            groupName = ""
            talkingSubject = ""
            groupQuestionList = []
            meetingDate = ""
        }
        
        init(group: GroupInfo, meeting: MeetingInfo) {
            groupName = group.groupName
            talkingSubject = meeting.talkingSubject
            groupQuestionList = meeting.groupQuestionList
            meetingDate = meeting.meetingDate
        }
    }
}
