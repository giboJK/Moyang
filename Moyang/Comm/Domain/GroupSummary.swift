//
//  GroupSummary.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/25.
//

// MARK: - GroupSummary
struct GroupSummary: Codable {
    let groupID: String
    let groupName: String
    let amens: [GroupSummaryAmen]
    let prays: [GroupSummaryPray]
    
    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case groupName = "group_name"
        case amens = "amens"
        case prays = "prays"
    }
}

struct GroupSummaryPray: Codable {
    let userID: String
    let userName: String
    let prayID: String?
    let content: String?
    let tags: [String]
    let isSecret: Bool
    let latestDate: String?
    let createDate: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case prayID = "pray_id"
        case content = "content"
        case tags = "tags"
        case isSecret = "is_secret"
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
