//
//  NewSermonVMMock.swift
//  Moyang
//
//  Created by kibo on 2022/02/06.
//

import SwiftUI
import Combine

class NewSermonVMMock: NewSermonVM {
    override init() {
        super.init()
        fetchSermonItem()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    override func fetchSermonItem() {
        title = "한 사람"
        subtitle = "회복(4)"
        bible = "누가복음 8:26 - 8:39"
        
        let uuid = UUID().uuidString
        
        let aQuestion = Question(sentence: "오늘 본문을 읽고 가장 기억에 남는 장면은 무엇인가? 살면서 놀라운 기적을 경험해 본 일이 있다면 나눠보자",
                                 answer: "목사님의 답답답",
                                 isAnswered: false)
        let aGroupQuestion = GroupQuestion(question: aQuestion,
                                           subquestionList: nil)
        
        let bSubQuestionOne = Question(sentence: "귀신들린 광인이 있던 동네는 어디였고, 그 주민들은 무엇을 하고 있었는가?",
                                       answer: "거라사 지방.",
                                       isAnswered: false)
        
        let bSubQuestionTwo = Question(sentence: "예수님이 기적을 펼치시고 사람들의 반응은 어떠했는가?",
                                       answer: "이 지역을 떠나달라고 요청함",
                                       isAnswered: false)
        let bGroupQuestion = GroupQuestion(question: nil, subquestionList: [bSubQuestionOne, bSubQuestionTwo])
        
        self.groupQuestionList = [aGroupQuestion, bGroupQuestion]
    }
}
