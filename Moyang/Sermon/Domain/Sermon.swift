//
//  Sermon.swift
//  Moyang
//
//  Created by kibo on 2022/02/06.
//

import Foundation

struct Sermon: Codable {
    var title: String
    let subtitle: String
    let bible: String
    let pastor: String
    let memberID: String
    let date: String
    let groupQuestionList: [GroupQuestion]
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case bible
        case pastor
        case memberID = "member_id"
        case date
        case groupQuestionList = "group_question_list"
    }
}
