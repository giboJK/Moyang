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
    var groupInfo: GroupInfo?
    
    @Published var itemList = [NewGroupPrayVM.NewPrayItem]()
    @Published var date = Date()
    @Published var isAddSuccess = false
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }

    init(repo: GroupRepo, groupInfo: GroupInfo?) {
        self.repo = repo
        if groupInfo == nil {
            self.groupInfo = UserData.shared.groupInfo
        } else {
            self.groupInfo = groupInfo
        }
        loadCellMemberList()
    }
    
    private func loadCellMemberList() {
        guard let groupInfo = groupInfo else { return }
        var list = [NewPrayItem]()
        groupInfo.memberList.forEach { member in
            list.append(NewPrayItem(member: member))
        }
        self.itemList = list
    }
    
    func addNewPray() {
        guard let groupInfo = groupInfo else { return }
        var data = GroupMemberPrayList(id: UUID().uuidString,
                                       date: date.toString("yyyy-MM-dd hh:mm:ss"),
                                       list: [])
        itemList.forEach { item in
            data.list.append(item.toGroupMemberPray())
        }
        
        repo.add(date, data, groupInfo: groupInfo)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Log.i(completion)
                case .failure(let error):
                    Log.e(error)
                }
            }) { _ in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewGroupPrayAdded"), object: nil)
                self.shouldDismissView = true
            }.store(in: &cancellables)
    }
}

extension NewGroupPrayVM {
    struct NewPrayItem {
        var member: Member
        var pray: String
        
        init(member: Member) {
            self.member = member
            self.pray = "기도제목을 입력하세요"
        }
        
        func toGroupMemberPray() -> GroupMemberPray {
            if self.pray == "기도제목을 입력하세요" {
                return GroupMemberPray(member: self.member,
                                       pray: "")
            }
            return GroupMemberPray(member: self.member,
                                   pray: self.pray)
        }
    }
}
