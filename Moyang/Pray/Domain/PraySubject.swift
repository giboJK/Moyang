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
    let createdTimestamp: String
    let praySubject: String
    let prayAlarmTime: String
    let prayDayList: [String]
    let prayTime: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdTimestamp = "create_timestamp"
        case praySubject = "pray_subject"
        case prayAlarmTime = "alarm_time"
        case prayDayList = "pray_day_list"
        case prayTime = "pray_time"
    }
}
