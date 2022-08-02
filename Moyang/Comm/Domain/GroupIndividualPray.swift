//
//  GroupIndividualPray.swift
//  Moyang
//
//  Created by kibo on 2022/04/23.
//

// MARK: - GroupIndividualPray
struct GroupIndividualPray: Codable {
    let id: String
    let groupID: String
    var date: String
    var pray: String
    var tags: [String]
    var changes: [PrayChange]
    var reactions: [PrayReaction]
    var replys: [PrayReply]
    let parentPrayID: String?
    let prayWithMemberID: String?
    var isSecret: Bool
    var isAnswered: Bool
    var answer: String
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case date
        case pray
        case tags
        case changes
        case reactions
        case replys
        case parentPrayID = "parent_pray_id"
        case prayWithMemberID = "pray_with_member_id"
        case isSecret = "is_secret"
        case isAnswered = "is_answered"
        case answer
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

struct PrayReaction: Codable {
    let memberID: String
    let name: String
    var type: Int
    var reaction: String
    
    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case name = "user_name"
        case type
        case reaction
    }
}

enum PrayReactionType: String, CaseIterable {
    case love
    case joyful
    case sad
    case prayWithYou
    
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
    let date: String
    var reactions: [PrayReaction]
    
    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case name = "user_name"
        case reply
        case date = "create_date"
        case reactions
    }
}
