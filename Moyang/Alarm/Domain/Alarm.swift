//
//  Alarm.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/29.
//

import Foundation

struct Alarm: Codable {
    let id: String
    let time: String
    let isOn: Bool
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case time = "time"
        case isOn = "is_on"
        case type = "type"
    }
}
