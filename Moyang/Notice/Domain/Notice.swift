//
//  Notice.swift
//  Moyang
//
//  Created by kibo on 2022/10/05.
//

import Foundation

struct Notice: Codable {
    let id: String
    let title: String
    let content: Bool
    let date: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case date
    }
}

