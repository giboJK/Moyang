//
//  GroupMember.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/06.
//

import Foundation

struct GroupMember: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    var name: String
    let profileURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case profileURL = "url"
    }
}

struct MemberDetail: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    var memberName: String
    var sex: String
    var birth: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case memberName = "member_name"
        case sex
        case birth
    }
}
