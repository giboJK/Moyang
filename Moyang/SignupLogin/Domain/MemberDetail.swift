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
    let prayInfo: PrayInfo?
    
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
        case prayInfo = "pray_info"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        authType = try container.decode(String.self, forKey: .authType)
        memberName = try container.decode(String.self, forKey: .memberName)
        birth = try container.decode(String.self, forKey: .birth)
        email = try container.decode(String.self, forKey: .email)
        groupList = try container.decode([String].self, forKey: .groupList)
        mainGroup = try container.decode(String.self, forKey: .mainGroup)
        startDate = try container.decode(String.self, forKey: .startDate)
        community = try container.decode(String.self, forKey: .community)
        grade = try container.decode(Int.self, forKey: .grade)
        isPastor = try container.decode(Bool.self, forKey: .isPastor)
        church = try? container.decode(ChurchInfo.self, forKey: .church)
        prayInfo = try? container.decode(PrayInfo.self, forKey: .prayInfo)
    }
    
    init(id: Identifier,
         authType: String,
         memberName: String,
         birth: String,
         email: String,
         groupList: [String],
         mainGroup: String,
         startDate: String,
         community: String,
         grade: Int,
         isPastor: Bool
    ) {
        self.id = id
        self.authType = authType
        self.memberName = memberName
        self.birth = birth
        self.email = email
        self.groupList = groupList
        self.mainGroup = mainGroup
        self.startDate = startDate
        self.community = community
        self.grade = grade
        self.isPastor = isPastor
        self.church = nil
        self.prayInfo = nil
    }
}

struct PrayInfo: Codable {
    var prayRecordList: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case prayRecordList = "pray_list"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prayRecordList = try? container.decode([String: Any].self, forKey: .prayRecordList)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let data = try JSONSerialization.data(withJSONObject: prayRecordList as Any, options: [])
        try container.encode(data, forKey: .prayRecordList)
    }
}

struct PrayTimeRecord: Codable {
    let date: String
    let time: Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case time
    }
}

struct PrayTimeRecordList: Codable {
    let list: [PrayTimeRecord]
    
    enum CodingKeys: String, CodingKey {
        case list = "amen_record"
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

struct Post: Codable {
    let userID, id: Int
    let title: String
    let body: [String: Any]
    let arrayOfObj: [[String: Any]]
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body, codedObj, arrayOfObj
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decode(Int.self, forKey: .userID)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode([String: Any].self, forKey: .body)
        arrayOfObj = try container.decode([[String: Any]].self, forKey: .arrayOfObj)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encodeIfPresent(userID, forKey: .userID)
        try? container.encodeIfPresent(id, forKey: .id)
        try? container.encodeIfPresent(title, forKey: .title)
        try? container.encodeIfPresent(body, forKey: .body)
        try? container.encodeIfPresent(arrayOfObj, forKey: .arrayOfObj)
    }
}
