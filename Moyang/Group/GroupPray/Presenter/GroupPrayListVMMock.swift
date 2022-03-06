//
//  GroupPrayListVMMock.swift
//  Moyang
//
//  Created by kibo on 2022/03/06.
//

import Combine
import Foundation

class GroupPrayListVMMock: GroupPrayListVM {
    init() {
        super.init(groupRepo: GroupRepoImpl(service: FirestoreServiceImpl()))
    }
    
    override func loadData() {
        var memberPrayList = [GroupMemberPray]()
        
        let memberA = Member(id: UUID().uuidString,
                             name: "이름 A",
                             email: "",
                             profileURL: "")
        let memberB = Member(id: UUID().uuidString,
                             name: "이름 B",
                             email: "",
                             profileURL: "")
        
        memberPrayList.append(GroupMemberPray(member: memberA,
                                              pray: "기도제목 1입니다"))
        memberPrayList.append(GroupMemberPray(member: memberB,
                                              pray: "기도제목 22입니다"))
        let data = [GroupMemberPrayList(id: "asdsadsadsad", date: "2022.03.22", list: memberPrayList)]
        
        
        let groupPrayListItem = GroupPrayListItem(data: data, groupInfo: GroupInfo(id: UUID().uuidString,
                                                                                   createdDate: Date().toString(format: "yyyy.MM.dd"),
                                                                                   groupName: "테스트셀",
                                                                                   parentGroup: UUID().uuidString,
                                                                                   leaderList: [],
                                                                                   memberList: [memberA, memberB]))
        self.nameItemList = groupPrayListItem.nameSortedItemList
        self.dateItemList = groupPrayListItem.dateSortedItemList
    }
}
