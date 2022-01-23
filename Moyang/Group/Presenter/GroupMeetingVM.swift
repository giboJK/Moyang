//
//  GroupMeetingVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/21.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class GroupMeetingVM: ObservableObject {
    @Published var answerList: [String] = Array(repeating: "", count: 10)
    @Published var groupInfoItem: GroupInfoItem = GroupInfoItem()
    
    private var cancellables = Set<AnyCancellable>()
    private var groupInfo: GroupInfo?
    
    private var repo: GroupRepo
    @Published var isAddSuccess = false
    
    init(repo: GroupRepo) {
        self.repo = repo
        groupInfoItem = GroupInfoItem()
        
        fetchMainGroupInfo()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.newGroupPrayAdded),
                                               name: NSNotification.Name(rawValue: "NewGroupPrayAdded"),
                                               object: nil)
    }
    
    @objc func newGroupPrayAdded(notif: NSNotification) {
          isAddSuccess = true
    }
    func fetchMainGroupInfo() {
        repo.fetchGroupInfo()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { data in
                self.groupInfo = data
                UserData.shared.groupInfo = data
                self.fetchMeetingInfo(parentGroup: data.parentGroup)
            })
            .store(in: &cancellables)
    }
    
    func fetchMeetingInfo(parentGroup: String) {
        repo.fetchMeetingInfo(parentGroup: parentGroup, date: "2022-01-16")
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { [weak self] meetingInfo in
                guard let groupInfo = self?.groupInfo else {
                    return
                }
                self?.groupInfoItem = GroupInfoItem(group: groupInfo, meeting: meetingInfo)
            })
            .store(in: &cancellables)
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}

extension GroupMeetingVM {
    typealias Identifier = Int
    struct GroupInfoItem {
        var groupName: String
        let talkingSubject: String
        var questionList: [String]
        let meetingDate: String
        
        init() {
            groupName = ""
            talkingSubject = ""
            questionList = []
            meetingDate = ""
        }
        
        init(group: GroupInfo, meeting: MeetingInfo) {
            groupName = group.groupName
            talkingSubject = meeting.talkingSubject
            questionList = meeting.questionList
            meetingDate = meeting.meetingDate
        }
    }
}
