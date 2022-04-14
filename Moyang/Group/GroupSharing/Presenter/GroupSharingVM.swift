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
    @Published var groupName = ""
    @Published var talkingSubject: String = ""
    @Published var groupQuestionList: [GroupQuestion] = []
    @Published var meetingDate: String = ""
    
    init(repo: GroupRepo, groupInfo: GroupInfo?) {
        self.repo = repo
        setGroupData(groupInfo: groupInfo)
        setSermonData()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    private func setGroupData(groupInfo: GroupInfo?) {
        guard let groupInfo = groupInfo else { Log.e(""); return }
        groupName = groupInfo.groupName
    }
    
    func setSermonData() {
        guard let sermon = UserData.shared.sermon else { Log.e(""); return }
        talkingSubject = sermon.title
        groupQuestionList = sermon.groupQuestionList
        meetingDate = sermon.date
    }
}
