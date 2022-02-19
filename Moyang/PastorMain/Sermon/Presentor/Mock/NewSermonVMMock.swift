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
        generateFakeItem()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    private func generateFakeItem() {
        title = "한 사람"
        subtitle = "회복(4)"
        bible = "누가복음 8:26 - 8:39"
        worship = "주일청년예배"
        
        groupQuestionListVM = GroupQuestionListVMMock()
    }
}
