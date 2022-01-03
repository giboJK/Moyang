//
//  PraySubject.swift
//  Moyang
//
//  Created by 정김기보 on 2021/09/14.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation

struct Pray: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let type: String
    let createdTimestamp: String
    let praySubject: String
    let isAlarmOn: Bool
    let prayAlarmTime: String
    let prayDayList: [String]
    let prayTime: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case type = "pray_type"
        case createdTimestamp = "create_timestamp"
        case praySubject = "pray_subject"
        case isAlarmOn = "is_alarm_on"
        case prayAlarmTime = "pray_alarm_time"
        case prayDayList = "pray_day_list"
        case prayTime = "pray_time"
    }
}

enum PrayType: String {
    case markedMy = "marked_my"
    case markedGroup = "marked_group"
    case my
    case group
    
    var title: String {
        switch self {
        case .markedMy:
            return "관심 기도"
        case .markedGroup:
            return "관심 기도"
        case .my:
            return "나의 기도"
        case .group:
            return "그룹"
        }
    }
}
