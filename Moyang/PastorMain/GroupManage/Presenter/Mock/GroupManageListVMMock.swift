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
                                                   groupName: "깐부셀",
                                                   groupPath: "2022_cell_kkh",
                                                   parentGroup: "yd_youth",
                                                   leader: GroupMember(id: UUID().uuidString,
                                                                       name: "조경환",
                                                                       profileURL: ""),
                                                   memberList: [GroupMember(id: UUID().uuidString,
                                                                            name: "길지윤",
                                                                            profileURL: ""),
                                                                GroupMember(id: UUID().uuidString,
                                                                            name: "정김기보",
                                                                            profileURL: ""),
                                                                GroupMember(id: UUID().uuidString,
                                                                            name: "김동현",
                                                                            profileURL: ""),
                                                                GroupMember(id: UUID().uuidString,
                                                                            name: "김승규",
                                                                            profileURL: ""),
                                                                GroupMember(id: UUID().uuidString,
                                                                            name: "박빛나",
                                                                            profileURL: "")]))
        itemList.append(itemA)
        let itemB = GroupItem(groupInfo: GroupInfo(id: UUID().uuidString,
                                                   groupName: "고등두3-1",
                                                   groupPath: "2022_high301",
                                                   parentGroup: "high",
                                                   leader: GroupMember(id: UUID().uuidString,
                                                                       name: "정김기보",
                                                                       profileURL: ""),
                                                   memberList: [GroupMember(id: UUID().uuidString,
                                                                            name: "김한결",
                                                                            profileURL: ""),
                                                                GroupMember(id: UUID().uuidString,
                                                                            name: "김민준",
                                                                            profileURL: ""),
                                                                GroupMember(id: UUID().uuidString,
                                                                            name: "박승호",
                                                                            profileURL: ""),
                                                                GroupMember(id: UUID().uuidString,
                                                                            name: "황보예원",
                                                                            profileURL: ""),
                                                                GroupMember(id: UUID().uuidString,
                                                                            name: "장예람",
                                                                            profileURL: "")]))
        itemList.append(itemB)
        
        self.itemList = itemList
    }
}
