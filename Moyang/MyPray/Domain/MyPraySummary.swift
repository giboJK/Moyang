//
//  MyPraySummary.swift
//  Moyang
//
//  Created by kibo on 2022/11/04.
//

import Foundation

struct MyPraySummary: Codable {
    let pray: MyPray?
    let alarm: PrayAlarm?
    let prayCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case pray
        case alarm
        case prayCount = "pray_count"
    }
}

struct PrayAlarm: Codable {
    let id: String
    let time: String
    let isOn: Bool
    let type: String
    let day: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case time
        case isOn = "is_on"
        case type
        case day
    }
}
