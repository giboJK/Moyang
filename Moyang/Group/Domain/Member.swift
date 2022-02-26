//
//  Member.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/06.
//

import Foundation

struct Member: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    var name: String
    let profileURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case profileURL = "url"
    }
}
