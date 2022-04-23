//
//  GroupManageListVMMock.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI
import Combine

class GroupManageListVMMock: GroupManageListVM {
    override init() {
        super.init()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    override func fetchItemList() {
        var itemList = [GroupItem]()
        let itemA = GroupItem(groupInfo: GroupInfo(id: UUID().uuidString,
                                                   createdDate: Date().toString("yyyy.MM.dd"),
                                                   groupName: "깐부셀",
                                                   parentGroup: "yd_youth",
                                                   leaderList: [Member(id: UUID().uuidString,
                                                                       name: "조경환",
                                                                       email: "test@test.com",
                                                                       profileURL: "",
                                                                       auth: "EMAIL")],
                                                   memberList: [Member(id: UUID().uuidString,
                                                                       name: "길지윤",
                                                                       email: "test@test.com",
                                                                       profileURL: "",
                                                                       auth: "EMAIL"),
                                                                Member(id: UUID().uuidString,
                                                                       name: "정김기보",
                                                                       email: "test@test.com",
                                                                       profileURL: "",
                                                                       auth: "EMAIL")]))
        itemList.append(itemA)
        let itemB = GroupItem(groupInfo: GroupInfo(id: UUID().uuidString,
                                                   createdDate: Date().toString("yyyy.MM.dd"),
                                                   groupName: "고등두3-1",
                                                   parentGroup: "high",
                                                   leaderList: [Member(id: UUID().uuidString,
                                                                       name: "정김기보",
                                                                       email: "test@test.com",
                                                                       profileURL: "",
                                                                       auth: "EMAIL")],
                                                   memberList: [Member(id: UUID().uuidString,
                                                                       name: "김한결",
                                                                       email: "test@test.com",
                                                                       profileURL: "",
                                                                       auth: "EMAIL"),
                                                                Member(id: UUID().uuidString,
                                                                       name: "김민준",
                                                                       email: "test@test.com",
                                                                       profileURL: "",
                                                                       auth: "EMAIL")]))
        itemList.append(itemB)
        
        self.itemList = itemList
    }
}
