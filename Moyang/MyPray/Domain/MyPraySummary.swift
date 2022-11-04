//
//  MyPraySummary.swift
//  Moyang
//
//  Created by kibo on 2022/11/04.
//

import Foundation

struct MyPraySummary: Codable {
    let pray: MyPray
    let alarms: [Alarm]
    let prayCount: Int
    
    enum CodingKeys: String, CodingKey {
        case pray
        case alarms
        case prayCount = "pray_count"
    }
}
