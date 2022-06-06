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
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case date
        case pray
        case tags
        case reactions
        case replys
    }
}

struct PrayReaction: Codable {
    let memberID: String
    let reaction: Int
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case reaction
        case date
    }
}

enum PrayReactionCase: Int, CaseIterable {
    case good = 0
    case sad = 1
    case joyful = 2
    case prayWithYou = 3
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
