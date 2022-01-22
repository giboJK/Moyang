//
//  NewGroupPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/30.
//

import SwiftUI
import Combine

class NewGroupPrayVM: ObservableObject, Identifiable {
    private let repo: GroupRepo
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var itemList = [NewGroupPrayVM.NewPrayItem]()
    @Published var dateString = Date().toString()
    @Published var isAddSuccess = false
    
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
        var data = GroupMemberPrayList(list: [])
        itemList.forEach { item in
            data.list.append(item.toGroupMemberPray())
        }
        
        repo.add(data, groupInfo: groupInfo)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Log.i(completion)
                case .failure(let error):
                    Log.e(error)
                }
            }) { isAddSuccess in
                self.isAddSuccess = isAddSuccess
            }.store(in: &cancellables)
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
