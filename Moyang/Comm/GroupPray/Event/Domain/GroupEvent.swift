//
//  GroupEvent.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/31.
//

import Foundation
struct GroupEvent: Codable {
    let id: String
    let createDate: String
    let userID: String
    let userName: String
    let targetUserID: String?
    let targetUserName: String?
    let eventType: String
    let preview: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createDate = "create_date"
        case userID = "user_id"
        case userName = "user_name"
        case targetUserID = "target_user_id"
        case targetUserName = "target_user_name"
        case eventType = "event_type"
        case preview = "preview"
        
    }
}

class GroupEventResponse: BaseResponse {
    let data: [GroupEvent]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([GroupEvent].self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
