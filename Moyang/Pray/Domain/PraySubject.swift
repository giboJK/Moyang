//
//  PraySubject.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/14.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation

struct PraySubject: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let subject: String
    let timeString: String
    let prayDayList: [String]
    let prayTime: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case subject
        case timeString = "time_string"
        case prayDayList = "pray_day_list"
        case prayTime = "pray_time"
    }
}
