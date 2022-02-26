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
                                                                       profileURL: "")],
                                                   memberList: [Member(id: UUID().uuidString,
                                                                            name: "길지윤",
                                                                            profileURL: ""),
                                                                Member(id: UUID().uuidString,
                                                                            name: "정김기보",
                                                                            profileURL: ""),
                                                                Member(id: UUID().uuidString,
                                                                            name: "김동현",
                                                                            profileURL: ""),
                                                                Member(id: UUID().uuidString,
                                                                            name: "김승규",
                                                                            profileURL: ""),
                                                                Member(id: UUID().uuidString,
                                                                            name: "박빛나",
                                                                            profileURL: "")]))
        itemList.append(itemA)
        let itemB = GroupItem(groupInfo: GroupInfo(id: UUID().uuidString,
                                                   createdDate: Date().toString("yyyy.MM.dd"),
                                                   groupName: "고등두3-1",
                                                   parentGroup: "high",
                                                   leaderList: [Member(id: UUID().uuidString,
                                                                       name: "정김기보",
                                                                       profileURL: "")],
                                                   memberList: [Member(id: UUID().uuidString,
                                                                            name: "김한결",
                                                                            profileURL: ""),
                                                                Member(id: UUID().uuidString,
                                                                            name: "김민준",
                                                                            profileURL: ""),
                                                                Member(id: UUID().uuidString,
                                                                            name: "박승호",
                                                                            profileURL: ""),
                                                                Member(id: UUID().uuidString,
                                                                            name: "황보예원",
                                                                            profileURL: ""),
                                                                Member(id: UUID().uuidString,
                                                                            name: "장예람",
                                                                            profileURL: "")]))
        itemList.append(itemB)
        
        self.itemList = itemList
    }
}
