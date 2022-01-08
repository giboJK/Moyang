//
//  Summary.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import Foundation

struct Summary: Codable {
    let cellId: String
    let groupName: String
    let cellTalkingSubject: String
    let cellMeetingDate: String
    let cellMemberList: [[String: String]]
    let qtId: String
    let qtName: String
    let qtSubject: String
    let prayId: String
    let prayType: String
    let praySubject: String
    let prayIsAlarmOn: Bool
    let prayAlarmTime: String
    let prayCreatedTimestamp: String
    let prayDayList: [String]
    let prayTime: String
    
    enum CodingKeys: String, CodingKey {
        case cellId = "cell_id"
        case groupName = "cell_name"
        case cellTalkingSubject = "cell_talking_subject"
        case cellMeetingDate = "cell_meeting_date"
        case cellMemberList = "cell_member_list"
        case qtId = "qt_id"
        case qtName = "qt_name"
        case qtSubject = "qt_subject"
        case prayId = "pray_id"
        case prayType = "pray_type"
        case praySubject = "pray_subject"
        case prayIsAlarmOn = "pray_is_alarm_on"
        case prayAlarmTime = "pray_alarm_time"
        case prayCreatedTimestamp = "pray_created_timestamp"
        case prayDayList = "pray_day_list"
        case prayTime = "pray_time"
    }
}
