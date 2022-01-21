//
//  NewGroupPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/30.
//

import SwiftUI
import Combine

class NewGroupPrayVM: ObservableObject, Identifiable {
    @Published var itemList = [NewGroupPrayVM.NewPrayItem]()
    @Published var dateString = Date().toString()
    
    private let repo: GroupRepo
    
    init(repo: GroupRepo) {
        self.repo = repo
        loadCellMemberList()
    }
    
    func changeDate(date: Date) {
        dateString = date.toString()
    }
    
    private func loadCellMemberList() {
        guard let groupInfo = UserData.shared.groupInfo else { return }
        var list = [NewPrayItem]()
        groupInfo.memberList.forEach { member in
            list.append(NewPrayItem(member: member))
        }
        self.itemList = list
    }
    
    func addNewPray() {
        guard let groupInfo = UserData.shared.groupInfo else { return }
        let id = String.randomString(length: 24)
        var list = [GroupMemberPray]()
        itemList.forEach { item in
            list.append(item.toGroupMemberPray())
        }
        
        
    }
}

extension NewGroupPrayVM {
    struct NewPrayItem: Hashable {
        var memberID: String
        var name: String
        var pray: String
        
        init(member: GroupMember) {
            self.memberID = member.id
            self.name = member.name
            self.pray = "기도제목을 입력하세요"
        }
        
        func toGroupMemberPray() -> GroupMemberPray {
            return GroupMemberPray(id: self.memberID,
                                   memberName: self.name,
                                   pray: self.pray)
        }
    }
}
