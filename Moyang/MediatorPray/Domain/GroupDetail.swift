//
//  GroupDetail.swift
//  Moyang
//
//  Created by kibo on 2022/11/22.
//

import Foundation
struct GroupDetail: Codable {
    let prays: [GroupDetailPray]
    let members: [GroupMember]
    let reqs: [GroupJoinReq]
    
    enum CodingKeys: String, CodingKey {
        case prays
        case members
        case reqs
    }
}

struct GroupDetailPray: Codable {
    let userID: String
    let userName: String
    let prayID: String
    let category: String
    let latestDate: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case prayID = "pray_id"
        case category = "category"
        case latestDate = "latest_date"
    }
}

struct GroupMember: Codable {
    let userID: String
    let userName: String
    let isLeader: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "name"
        case isLeader = "is_leader"
    }
}

struct GroupJoinReq: Codable {
    let reqID: String
    let userName: String
    let userID: String
    let requestDate: String
    
    enum CodingKeys: String, CodingKey {
        case reqID = "req_id"
        case userName = "name"
        case userID = "user_id"
        case requestDate = "request_date"
    }
}
