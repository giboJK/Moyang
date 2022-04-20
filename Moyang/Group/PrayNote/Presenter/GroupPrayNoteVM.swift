//
//  GroupPrayNoteVM.swift
//  Moyang
//
//  Created by kibo on 2022/04/20.
//

import SwiftUI
import Combine

class GroupPrayNoteVM: ObservableObject {
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

extension GroupPrayNoteVM {
    struct GroupPrayNoteItem {
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

