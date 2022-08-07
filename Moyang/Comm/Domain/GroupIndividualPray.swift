//
//  GroupIndividualPray.swift
//  Moyang
//
//  Created by kibo on 2022/04/23.
//

// MARK: - GroupIndividualPray
struct GroupIndividualPray: Codable {
    let userID: String
    let userName: String
    let groupID: String
    let prayID: String
    var pray: String
    var tags: [String]
    var changes: [PrayChange]
    var reactions: [PrayReaction]
    var replys: [PrayReply]
    var isSecret: Bool
    var isAnswered: Bool
    var answers: [PrayAnswer]
    var latestDate: String
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case groupID = "group_id"
        case prayID = "pray_id"
        case pray = "content"
        case tags
        case changes
        case reactions
        case replys = "replys"
        case isSecret = "is_secret"
        case isAnswered = "is_answered"
        case answers = "answers"
        case latestDate = "latest_date"
        case createDate = "create_date"
    }
}

struct PrayChange: Codable {
    let content: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case content
        case date = "create_date"
    }
}

struct PrayAnswer: Codable {
    let answer: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case answer
        case date = "create_date"
    }
}

struct PrayReaction: Codable {
    let memberID: String
    let name: String
    var type: Int
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case memberID = "user_id"
        case name = "user_name"
        case type
        case createDate = "create_date"
    }
}

enum PrayReactionType: Int, CaseIterable {
    case love = 0
    case joyful = 1
    case sad = 2
    case prayWithYou = 3
    
    var desc: String {
        switch self {
        case .love:
            return "❤️"
        case .joyful:
            return "😊"
        case .sad:
            return "😭"
        case .prayWithYou:
            return "🙏"
        }
    }
    var order: Int {
        switch self {
        case .love:
            return 0
        case .joyful:
            return 1
        case .sad:
            return 2
        case .prayWithYou:
            return 3
        }
    }
}

struct PrayReply: Codable {
    let memberID: String
    let name: String
    let reply: String
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case memberID = "user_id"
        case name = "user_name"
        case reply
        case createDate = "create_date"
    }
}
