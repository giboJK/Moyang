//
//  GroupInfo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/25.
//

import Foundation

struct GroupInfo: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let createDate: String
    let groupName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "group_name"
        case createDate = "create_date"
    }
}
