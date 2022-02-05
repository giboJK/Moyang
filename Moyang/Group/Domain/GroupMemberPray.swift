//
//  GroupMemberPray.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Foundation
import SwiftUI

// MARK: - GroupMemberPray
struct GroupMemberPray: Codable {
    let member: GroupMember
    let pray: String

    enum CodingKeys: String, CodingKey {
        case member
        case pray
    }
}

struct GroupMemberPrayList: Codable, Identifiable {
    var id: String
    var date: String
    var list: [GroupMemberPray]

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case list
    }
}
