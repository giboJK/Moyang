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
    let groupName: String
    let leader: GroupMember
    let memberList: [GroupMember]
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "group_name"
        case leader = "leader"
        case memberList = "member_list"
    }
}
