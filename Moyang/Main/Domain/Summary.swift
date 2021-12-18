//
//  Summary.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import Foundation

struct Summary: Codable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let cellName: String
    let cellTalkingSubject: String
    let cellMeetingDate: String
    let cellMemberList: [CellMember]
    let qtId: String
    let qtName: String
    let qtSubject: String
    let prayId: Identifier
    let praySubject: String
    let prayStartDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
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
    }
}
