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
    let cellMeetingSubject: String
    let cellMeetingDate: String
    let cellMemberName: [String]
    let qtName: String
    let qtSubject: String
    let praySubject: String
    let prayStartDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case cellName = "cell_name"
        case cellMeetingSubject = "cell_meeting_subject"
        case cellMeetingDate = "cell_meeting_date"
        case cellMemberName = "cell_member_name"
        case qtName = "qt_name"
        case qtSubject = "qt_subject"
        case praySubject = "pray_subject"
        case prayStartDate = "pray_start_date"
    }
}
