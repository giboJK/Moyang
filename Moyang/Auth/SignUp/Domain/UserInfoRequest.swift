//
//  UserInfoRequest.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation

struct UserInfoRequest: Codable {
    let email: String
    let passwd: String
    let name: String
    let authType: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case passwd = "user_pw"
        case name = "name"
        case authType = "auth_type"
    }
}

struct UserInfo: Codable {
    let id: String
    let email: String
    let name: String
    let isPastor: Bool
    let groupList: [GroupInfo]
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case name = "name"
        case isPastor = "is_pastor"
        case createDate = "create_date"
        case groupList = "group_list"
    }
}
