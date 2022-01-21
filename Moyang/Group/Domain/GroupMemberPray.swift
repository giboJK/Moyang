//
//  GroupMemberPray.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Foundation
import SwiftUI

// MARK: - GroupMemberPray
struct GroupMemberPray: Codable, Identifiable {
    let id: String
    let memberName: String
    let pray: String

    enum CodingKeys: String, CodingKey {
        case id
        case memberName = "member_name"
        case pray = "pray"
    }
}
