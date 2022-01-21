//
//  DailyPreview.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import Foundation

struct DailyPreview: Codable {
    let groupId: String
    let groupName: String
    let groupTalkingSubject: String
    let groupMeetingDate: String
    let groupMemberList: [GroupMember]
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
        case groupId = "group_id"
        case groupName = "group_name"
        case groupTalkingSubject = "group_talking_subject"
        case groupMeetingDate = "group_meeting_date"
        case groupMemberList = "member_list"
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
