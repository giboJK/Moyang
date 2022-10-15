//
//  NoteCategory.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/16.
//

import Foundation

struct NoteCategory: Codable {
    let id: String
    let name: String
    let color: String
    let createDate: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case createDate = "create_date"
    }
}
