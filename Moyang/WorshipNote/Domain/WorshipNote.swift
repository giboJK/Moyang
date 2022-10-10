//
//  WorshipNote.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import Foundation

struct WorshipNote: Codable {
    let id: String
    let pastor: String
    let bible: String
    let title: String
    let content: String
    let date: String
    let tags: [String]
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case pastor
        case bible
        case title
        case content
        case date
        case tags
    }
}
