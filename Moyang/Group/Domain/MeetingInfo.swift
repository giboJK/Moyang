//
//  MeetingInfo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/17.
//

import Foundation

struct MeetingInfo: Codable {
    let meetingDate: String
    let talkingSubject: String
    let groupQuestionList: [GroupQuestion]
    
    enum CodingKeys: String, CodingKey {
        case meetingDate = "meeting_date"
        case talkingSubject = "talking_subject"
        case groupQuestionList = "group_question_list"
    }
}
