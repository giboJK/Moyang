//
//  GroupManageListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/18.
//

import SwiftUI
import Combine

class GroupManageListVM: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    @Published var itemList = [GroupItem]()
    
    init() {
        fetchItemList()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func fetchItemList() {
        
    }
}

extension GroupManageListVM {
    struct GroupItem: Identifiable {
        let id: String
        let name: String
        let leader: Member
        let memberList: [Member]
        let parentGroup: String
        
        init(groupInfo: GroupInfo) {
            id = UUID().uuidString
            name = groupInfo.groupName
            leader = groupInfo.leaderList[0]
            memberList = groupInfo.memberList
            parentGroup = groupInfo.parentGroup
        }
    }
}
