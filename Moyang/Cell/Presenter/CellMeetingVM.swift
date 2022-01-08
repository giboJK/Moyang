//
//  CellMeetingVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/21.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class CellMeetingVM: ObservableObject {
    @Published var answerList: [String] = Array(repeating: "", count: 10)
    @Published var cellInfo: GroupInfoItem
    
    private var disposables = Set<AnyCancellable>()
    
    private var groupRepo: GroupRepo
    
    init(groupRepo: GroupRepo) {
        self.groupRepo = groupRepo
        cellInfo = GroupInfoItem(cellInfo: GroupInfo(id: "",
                                                     groupName: "",
                                                     leader: CellMember(id: "",
                                                                        name: "",
                                                                        profileURL: ""),
                                                     memberList: []))
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
}

extension CellMeetingVM {
    typealias Identifier = Int
    struct GroupInfoItem {
        var cellName: String
        let talkingSubject: String
        var questionList: [String]
        let dateString: String
        
        init(cellInfo: GroupInfo) {
            cellName = cellInfo.groupName
            talkingSubject = "셀모임 주제~"
            questionList = ["아하하하 1", "우라라라라 2", "그우어ㅓ어3", "잇츠 퀘스쳔4"]
            dateString = "2022-01-02"
        }
    }
}
