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
    let birth: String
    let authType: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case passwd = "user_pw"
        case name = "name"
        case birth = "birth"
        case authType = "auth_type"
    }
}

struct UserInfo: Codable {
    let id: String
    let email: String
    let name: String
    let birth: String
    let isPastor: Bool
    let groupIDList: [String]
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case name = "name"
        case birth = "birth"
        case isPastor = "is_pastor"
        case createDate = "create_date"
        case groupIDList = "group_id_list"
    }
}
