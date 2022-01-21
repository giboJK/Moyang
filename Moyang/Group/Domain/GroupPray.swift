//
//  GroupPray.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Foundation
import SwiftUI

struct GroupPray: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let createdTimestamp: String
    let groupName: String
    let groupPrayList: [GroupPrayList]
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdTimestamp = "created_timestamp"
        case groupName = "group_name"
        case groupPrayList = "group_pray_list"
    }
}

// MARK: - GroupPrayList
struct GroupPrayList: Codable {
    let dateString: String
    let memberPrayList: [GroupMemberPray]
    
    enum CodingKeys: String, CodingKey {
        case dateString = "date_string"
        case memberPrayList = "member_pray_list"
    }
}

// MARK: - GroupMemberPray
struct GroupMemberPray: Codable {
    let memberName: String
    let pray: String

    enum CodingKeys: String, CodingKey {
        case memberName = "member_name"
        case pray = "pray"
    }
}
