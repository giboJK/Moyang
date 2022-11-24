//
//  GroupMemberPray.swift
//  Moyang
//
//  Created by kibo on 2022/11/23.
//

struct GroupMemberPray: Codable {
    let prayID: String
    let userID: String
    var category: String
    var content: String
    var latestDate: String
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case prayID = "pray_id"
        case userID = "user_id"
        case category = "category"
        case content = "content"
        case latestDate = "latest_date"
        case createDate = "create_date"
    }
}
