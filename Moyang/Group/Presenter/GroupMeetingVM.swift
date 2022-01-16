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
    @Published var groupInfo: GroupInfoItem
    
    private var cancellables = Set<AnyCancellable>()
    
    private var repo: GroupRepo
    
    init(repo: GroupRepo) {
        self.repo = repo
        groupInfo = GroupInfoItem(data: GroupInfo(id: "",
                                                  groupName: "",
                                                  leader: GroupMember(id: "",
                                                                      name: "",
                                                                      profileURL: ""),
                                                  memberList: []))
        
        fetchMainGroupInfo()
    }
    
    func fetchMainGroupInfo() {
        repo.fetchGroupInfo()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { data in
                self.groupInfo = GroupInfoItem(data: data)
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
        var cellName: String
        let talkingSubject: String
        var questionList: [String]
        let dateString: String
        
        init(data: GroupInfo) {
            cellName = data.groupName
            talkingSubject = "셀모임 주제~"
            questionList = ["아하하하 1", "우라라라라 2", "그우어ㅓ어3", "잇츠 퀘스쳔4"]
            dateString = "2022-01-02"
        }
    }
}
