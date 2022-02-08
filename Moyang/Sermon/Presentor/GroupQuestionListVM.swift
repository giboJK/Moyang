//
//  GroupQuestionListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/07.
//

import SwiftUI
import Combine

class GroupQuestionListVM: ObservableObject {
    var disposables = Set<AnyCancellable>()
    
    @Published var groupQuestionList = [GroupQuestion]()
    @Published var newQuestionAdded = false
    
    init() {
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func addQuestion() {
        groupQuestionList.append(GroupQuestion(question: Question(sentence: "입력하세요", answer: "입력하세요"),
                                               subquestionList: []))
        newQuestionAdded = true
        newQuestionAdded = false
    }
    
    func addSubQuestion(index: Int) {
        if index >= groupQuestionList.count {
            return 
        }
        groupQuestionList[index].subquestionList.append(Question(sentence: "입력하세요", answer: "입력하세요"))
    }
}
