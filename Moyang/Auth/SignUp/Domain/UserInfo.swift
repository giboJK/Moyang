//
//  UserInfo.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation

struct UserInfo: Codable, Identifiable {
    let id: String
    let name: String
    let passwd: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "name"
        case passwd = "user_pw"
    }
}
