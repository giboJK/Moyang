//
//  GroupQuestion.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import Foundation

struct GroupQuestion: Codable {
    var question: Question
    var subquestionList: [Question]
    
    enum CodingKeys: String, CodingKey {
        case question
        case subquestionList = "subquestion_list"
    }
}

struct Question: Codable {
    var sentence: String
    var answer: String
    var isAnswered: Bool
    
    enum CodingKeys: String, CodingKey {
        case sentence
        case answer
        case isAnswered = "is_answered"
    }
    
    init() {
        sentence = ""
        answer = ""
        isAnswered = false
    }
    
    init(sentence: String, answer: String, isAnswered: Bool = false) {
        self.sentence = sentence
        self.answer = answer
        self.isAnswered = isAnswered
    }
}
