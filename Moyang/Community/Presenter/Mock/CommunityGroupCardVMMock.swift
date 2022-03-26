//
//  CommunityGroupCardVMMock.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import Combine

class CommunityGroupCardVMMock: CommunityGroupCardVM {
    private var disposables = Set<AnyCancellable>()
    
    override init() {
        super.init()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    override func fetchLastSermon() {
        groupName = "셀이름"
//        let subQuestionOne = Question(sentence: "귀신들린 광인이 있던 동네는 어디였고, 그 주민들은 무엇을 하고 있었는가?",
//                                      answer: "거라사 지방.")
//        let subQuestionTwo = Question(sentence: "예수님이 기적을 펼치시고 사람들의 반응은 어떠했는가?",
//                                      answer: "이 지역을 떠나달라고 요청함")
//        let aQuestion = Question(sentence: "오늘 본문을 읽고 가장 기억에 남는 장면은 무엇인가? 살면서 놀라운 기적을 경험해 본 일이 있다면 나눠보자",
//                                 answer: "목사님의 답답답",
//                                 isAnswered: true)
//        let aGroupQuestion = GroupQuestion(question: aQuestion,
//                                           subquestionList: [subQuestionOne])
//
//        let bGroupQuestion = GroupQuestion(question: Question(),
//                                           subquestionList: [subQuestionOne, subQuestionTwo])
//
//        let groupQuestionList = [aGroupQuestion, bGroupQuestion]
//
    }
}
