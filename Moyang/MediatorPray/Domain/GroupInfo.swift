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

struct GroupMediatorInfo: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let name: String
    let desc: String
    let prayID: String?
    let prayName: String?
    let eventDate: String?
    var hasJoinEvent: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case desc = "desc"
        case prayID = "pray_id"
        case prayName = "pray_name"
        case eventDate = "event_date"
        case hasJoinEvent = "has_join_event"
    }
}

struct GroupSearchedInfo: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let createDate: String
    let name: String
    let desc: String
    let leader: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createDate = "create_date"
        case name
        case desc
        case leader
    }
}
