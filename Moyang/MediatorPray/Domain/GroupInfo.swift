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
    let name: String
    let desc: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createDate = "create_date"
        case name = "name"
        case desc = "desc"
    }
}
