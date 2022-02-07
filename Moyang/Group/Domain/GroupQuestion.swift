//
//  GroupQuestion.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import Foundation

struct GroupQuestion: Codable {
    let question: Question?
    let subquestionList: [Question]?
    
    enum CodingKeys: String, CodingKey {
        case question
        case subquestionList = "subquestion_list"
    }
}

struct Question: Codable {
    let sentence: String
    let answer: String
    let isAnswered: Bool
    
    enum CodingKeys: String, CodingKey {
        case sentence
        case answer
        case isAnswered = "is_answered"
    }
}
