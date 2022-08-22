//
//  GroupActivity.swift
//  Moyang
//
//  Created by kibo on 2022/08/22.
//

// MARK: - GroupActivity
struct GroupActivity: Codable {
    let amenList: [AmenActivityItem]
    let prayList: [PrayActivityItem]
    
    enum CodingKeys: String, CodingKey {
        case amenList = "amen_list"
        case prayList = "pray_list"
    }
}

struct AmenActivityItem: Codable {
    let date: String
    let userID: String
    let time: Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case userID = "user_id"
        case time
    }
}

struct PrayActivityItem: Codable {
    let date: String
    let userID: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case userID = "user_id"
    }
}


class GroupActivityResponse: BaseResponse {
    let data: GroupActivity
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(GroupActivity.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
