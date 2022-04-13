//
//  ChurchInfo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/04/13.
//

import Foundation

struct ChurchInfo: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let name: String
    let seniorPastor: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case seniorPastor = "senior_pastor"
    }
}
