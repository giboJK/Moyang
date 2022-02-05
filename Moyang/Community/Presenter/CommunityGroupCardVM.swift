//
//  CommunityGroupCardVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import Combine

class CommunityGroupCardVM: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    
    @Published var item = CommunityGroupCardVM.GroupItem()
    
    init() {
        fetchGroupItem()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func fetchGroupItem() {
        
    }
}

extension CommunityGroupCardVM {
    struct GroupItem {
        let groupName: String
        let questionDate: String
        let questionList: [String]
        let prayRegisterDate: String
        let lastestPrayDate: String
        let prayList: GroupMemberPrayList?
        
        init() {
            groupName = ""
            questionDate = ""
            questionList = []
            prayRegisterDate = ""
            lastestPrayDate = ""
            prayList = nil
        }
        
        init(groupName: String,
             questionDate: String,
             questionList: [String],
             prayRegisterDate: String,
             lastestPrayDate: String,
             prayList: GroupMemberPrayList?
        ) {
            self.groupName = groupName
            self.questionDate = questionDate
            self.questionList = questionList
            self.prayRegisterDate = prayRegisterDate
            self.lastestPrayDate = lastestPrayDate
            self.prayList = prayList
        }
    }
}

