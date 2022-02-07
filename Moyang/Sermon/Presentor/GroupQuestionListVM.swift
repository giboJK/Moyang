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
    
    init() {
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func addQuestion() {
        groupQuestionList.append(GroupQuestion(question: Question(),
                                               subquestionList: nil))
    }
    
    func addSubQuestion(index: Int) {
        if index >= groupQuestionList.count {
            return 
        }
        if groupQuestionList[index].subquestionList == nil {
            groupQuestionList[index].subquestionList = [Question]()
        } else {
            groupQuestionList[index].subquestionList?.append(Question())
        }
    }
}
