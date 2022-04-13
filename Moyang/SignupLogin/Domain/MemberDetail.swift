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
    let authType: String
    var memberName: String
    var birth: String
    var email: String
    let groupList: [String]
    let mainGroup: String
    let startDate: String
    let community: String
    let grade: Int
    let isPastor: Bool
    let church: ChurchInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case authType = "auth_type"
        case memberName = "member_name"
        case birth
        case email
        case groupList = "group_list"
        case mainGroup = "main_group"
        case startDate = "start_date"
        case community
        case grade
        case isPastor = "is_pastor"
        case church
    }
}


enum UserLevel: Int {
    case seed = 1
    case leaf = 2
    case fruit = 3
    case tree = 4
    
    var levelDesc: String {
        switch self {
        case .seed:
            return "새싹 그리스도인"
        case .leaf:
            return "풀잎 그리스도인"
        case .fruit:
            return "열매 그리스도인"
        case .tree:
            return "나무 그리스도인"
        }
    }
}
