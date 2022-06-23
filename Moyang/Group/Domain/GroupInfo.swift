//
//  GroupInfo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/25.
//

import Foundation

struct GroupInfo: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let createdDate: String
    let groupName: String
    let parentGroup: String
    let leaderList: [Member]
    let memberList: [Member]
    let pastorInCharge: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "group_name"
        case createdDate = "created_date"
        case parentGroup = "parent_group"
        case leaderList = "leader_list"
        case memberList = "member_list"
        case pastorInCharge = "pastor_in_charge"
    }
}
