//
//  Summary.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import Foundation

struct Summary: Codable {
    let cellId: String
    let cellName: String
    let cellTalkingSubject: String
    let cellMeetingDate: String
    let cellMemberList: [[String: String]]
    let qtId: String
    let qtName: String
    let qtSubject: String
    let prayId: String
    let praySubject: String
    let prayStartDate: String
    let prayDayList: [String]
    let prayTime: String
    
    enum CodingKeys: String, CodingKey {
        case cellId = "cell_id"
        case cellName = "cell_name"
        case cellTalkingSubject = "cell_talking_subject"
        case cellMeetingDate = "cell_meeting_date"
        case cellMemberList = "cell_member_list"
        case qtId = "qt_id"
        case qtName = "qt_name"
        case qtSubject = "qt_subject"
        case prayId = "pray_id"
        case praySubject = "pray_subject"
        case prayStartDate = "pray_start_date"
        case prayDayList = "pray_day_list"
        case prayTime = "pray_time"
    }
}
