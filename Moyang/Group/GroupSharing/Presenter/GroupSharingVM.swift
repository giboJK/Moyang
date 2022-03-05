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
    
    private var repo: GroupRepo
    
    @Published var answerList: [String] = Array(repeating: "", count: 10)
    @Published var groupInfoItem: GroupInfoItem = GroupInfoItem()
    
    init(repo: GroupRepo) {
        self.repo = repo
        setData()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func setData() {
        guard let groupInfo = UserData.shared.groupInfo else { Log.e(""); return }
        guard let sermon = UserData.shared.sermon else { Log.e(""); return }
        groupInfoItem = GroupInfoItem(group: groupInfo, sermon: sermon)
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
        
        init(group: GroupInfo, sermon: Sermon) {
            groupName = group.groupName
            talkingSubject = sermon.title
            groupQuestionList = sermon.groupQuestionList
            meetingDate = sermon.date
        }
    }
}
