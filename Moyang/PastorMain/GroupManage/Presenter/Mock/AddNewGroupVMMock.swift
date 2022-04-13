//
//  AddNewGroupVMMock.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI
import Combine

class AddNewGroupVMMock: AddNewGroupVM {
    override init() {
        super.init()
    }
    
    override func fetchMemberList() {
        let memberA = MemberDetail(id: UUID().uuidString,
                                   authType: "email",
                                   memberName: "정김기보",
                                   birth: "1989.06.30",
                                   email: "tete@tete.com",
                                   groupList: [],
                                   mainGroup: "",
                                   startDate: "",
                                   community: "YD",
                                   grade: 1,
                                   isPastor: false,
                                   church: nil)
        var itemA = SearchMemberItem(memberDetail: memberA)
        itemA.isLeader = true
        let memberB = MemberDetail(id: UUID().uuidString,
                                   authType: "email",
                                   memberName: "정김기",
                                   birth: "1989.06.30",
                                   email: "tete@tete.com",
                                   groupList: [],
                                   mainGroup: "",
                                   startDate: "",
                                   community: "YD",
                                   grade: 1,
                                   isPastor: false,
                                   church: nil)
        var itemB = SearchMemberItem(memberDetail: memberB)
        itemB.isMember = true
        let memberC = MemberDetail(id: UUID().uuidString,
                                   authType: "email",
                                   memberName: "김기보",
                                   birth: "1989.06.30",
                                   email: "tete@tete.com",
                                   groupList: [],
                                   mainGroup: "",
                                   startDate: "",
                                   community: "YD",
                                   grade: 1,
                                   isPastor: false,
                                   church: nil)
        var itemC = SearchMemberItem(memberDetail: memberC)
        itemC.isMember = true
        let memberD = MemberDetail(id: UUID().uuidString,
                                   authType: "email",
                                   memberName: "기보",
                                   birth: "1989.06.30",
                                   email: "tete@tete.com",
                                   groupList: [],
                                   mainGroup: "",
                                   startDate: "",
                                   community: "YD",
                                   grade: 1,
                                   isPastor: false,
                                   church: nil)
        let itemD = SearchMemberItem(memberDetail: memberD)
        let memberE = MemberDetail(id: UUID().uuidString,
                                   authType: "email",
                                   memberName: "길고길고 긴 이름 이름하야 정김기보",
                                   birth: "1989.06.30",
                                   email: "tete@tete.com",
                                   groupList: [],
                                   mainGroup: "",
                                   startDate: "",
                                   community: "YD",
                                   grade: 1,
                                   isPastor: false,
                                   church: nil)
        let itemE = SearchMemberItem(memberDetail: memberE)
        leaderItemList.append(contentsOf: [itemA,
                                           itemB,
                                           itemC,
                                           itemD,
                                           itemE])
        memberItemList.append(contentsOf: [itemA,
                                           itemB,
                                           itemC,
                                           itemD,
                                           itemE])
    }
}
