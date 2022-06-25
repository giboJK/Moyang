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
    let pray: String
    let tags: [String]
    let reactions: [PrayReaction]
    let replys: [PrayReply]
    let parentPrayID: String?
    let order: Int
    let isSecret: Bool
    let isRequestPray: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case date
        case pray
        case tags
        case reactions
        case replys
        case parentPrayID = "parent_pray_id"
        case order = "order"
        case isSecret = "is_secret"
        case isRequestPray = "is_request_pray"
    }
}

struct PrayReaction: Codable {
    let memberID: String
    let reaction: String
    
    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case reaction
    }
}

enum PrayReactionType: String, CaseIterable {
    case love
    case sad
    case joyful
    case prayWithYou
    
    var desc: String {
        switch self {
        case .love:
            return "😍"
        case .sad:
            return "😭"
        case .joyful:
            return "😊"
        case .prayWithYou:
            return "🙏"
        }
    }
}

struct PrayReply: Codable {
    let memberID: String
    let reply: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case reply
        case date
    }
}
