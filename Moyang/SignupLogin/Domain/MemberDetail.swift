//
//  MemberDetail.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import Foundation

struct MemberDetail: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    var memberName: String
    var sex: String
    var birth: String
    var email: String
    let groupList: [String]
    let mainGroup: String
    let startDate: String
    let community: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case memberName = "member_name"
        case sex
        case birth
        case email
        case groupList = "group_list"
        case mainGroup = "main_group"
        case startDate = "start_date"
        case community
    }
}

