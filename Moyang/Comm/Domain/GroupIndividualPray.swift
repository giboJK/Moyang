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
    let date: String
    var pray: String
    var tags: [String]
    var reactions: [PrayReaction]
    var replys: [PrayReply]
    let parentPrayID: String?
    let prayWithMemberID: String?
    var isSecret: Bool
    var isRequestPray: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case date
        case pray
        case tags
        case reactions
        case replys
        case parentPrayID = "parent_pray_id"
        case prayWithMemberID = "pray_with_member_id"
        case isSecret = "is_secret"
        case isRequestPray = "is_request_pray"
    }
}

struct PrayReaction: Codable {
    let memberID: String
    var reaction: String
    
    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
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
    let reply: String
    let date: String
    var reactions: [PrayReaction]
    let order: Int
    
    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case reply
        case date
        case reactions
        case order
    }
}
