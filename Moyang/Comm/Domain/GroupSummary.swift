//
//  GroupSummary.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/25.
//

// MARK: - GroupSummary
struct GroupSummary: Codable {
    let groupID: String
    let amens: [GroupSummaryAmen]
    let prays: [GroupSummaryPray]
    let groupInfo: GroupInfo
    
    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case amens = "amens"
        case prays = "prays"
        case groupInfo = "group_info"
    }
}

struct GroupSummaryPray: Codable {
    let userID: String
    let userName: String
    let prayID: String?
    let content: String?
    let answer: String?
    var changes: [PrayChange]?
    let isSecret: Bool?
    let isAnswered: Bool?
    let latestDate: String?
    let createDate: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case prayID = "pray_id"
        case content = "content"
        case answer = "answer"
        case changes = "changes"
        case isSecret = "is_secret"
        case isAnswered = "is_answered"
        case latestDate = "latest_date"
        case createDate = "create_date"
    }
}

struct GroupSummaryAmen: Codable {
    let amenID: String
    let time: Int
    let userID: String
    let userName: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case amenID = "amen_id"
        case time = "time"
        case userID = "user_id"
        case userName = "user_name"
        case date = "date"
    }
}
