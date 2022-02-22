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
                                   community: "YD")
        let itemA = SearchMemberItem(memberDetail: memberA)
        let memberB = MemberDetail(id: UUID().uuidString,
                                   authType: "email",
                                   memberName: "정김기",
                                   birth: "1989.06.30",
                                   email: "tete@tete.com",
                                   groupList: [],
                                   mainGroup: "",
                                   startDate: "",
                                   community: "YD")
        let itemB = SearchMemberItem(memberDetail: memberB)
        let memberC = MemberDetail(id: UUID().uuidString,
                                   authType: "email",
                                   memberName: "김기보",
                                   birth: "1989.06.30",
                                   email: "tete@tete.com",
                                   groupList: [],
                                   mainGroup: "",
                                   startDate: "",
                                   community: "YD")
        let itemC = SearchMemberItem(memberDetail: memberC)
        let memberD = MemberDetail(id: UUID().uuidString,
                                   authType: "email",
                                   memberName: "기보",
                                   birth: "1989.06.30",
                                   email: "tete@tete.com",
                                   groupList: [],
                                   mainGroup: "",
                                   startDate: "",
                                   community: "YD")
        let itemD = SearchMemberItem(memberDetail: memberD)
        let memberE = MemberDetail(id: UUID().uuidString,
                                   authType: "email",
                                   memberName: "정김기보",
                                   birth: "1989.06.30",
                                   email: "tete@tete.com",
                                   groupList: [],
                                   mainGroup: "",
                                   startDate: "",
                                   community: "YD")
        let itemE = SearchMemberItem(memberDetail: memberE)
        totalItemList.append(contentsOf: [itemA,
                                          itemB,
                                          itemC,
                                          itemD,
                                          itemE])
    }
}
