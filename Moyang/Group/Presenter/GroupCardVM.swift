//
//  GroupCardVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/18.
//

import SwiftUI
import Combine

class GroupCardVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var preview: GroupPreview
    @Published var randomMemberList: [Member]
    
    var maxDisplayedMembers = 7
    
    init(preview: GroupPreview) {
        self.preview = preview
        maxDisplayedMembers = min(5, preview.memberList.count)
        randomMemberList = preview.memberList[randomPick: maxDisplayedMembers]
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}

extension GroupCardVM {
    struct GroupPreviewItem {
        let name: String
        let date: String
        let questionList: [String]
        let lastPrayDate: String
        let prayList: [String]
        
        init(name: String,
             date: String,
             questionList: [String],
             lastPrayDate: String,
             prayList: [String]
        ) {
            self.name = name
            self.date = date
            self.questionList = questionList
            self.lastPrayDate = lastPrayDate
            self.prayList = prayList
        }
    }
}
