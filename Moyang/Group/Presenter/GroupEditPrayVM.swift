//
//  GroupEditPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/25.
//

import SwiftUI
import Combine

class GroupEditPrayVM: ObservableObject {
    private let groupRepo: GroupRepo
    var cancellables = Set<AnyCancellable>()
    var groupInfo: GroupInfo?
    
    @Published var nameItem = [(id: String, date: String, pray: String)]()
    @Published var dateItem = [(member: String, pray: String, isShowing: Bool)]()
    @Published var isEditSuccess = false
    
    @Published var prayTitle = ""
    @Published var prayContents = ""
    @Published var date = ""
    @Published var name = ""
    
    var maxDisplayedMembers = 5
    
    init(groupRepo: GroupRepo,
         nameItem: GroupPrayListVM.NameSortedItem? = nil,
         dateItem: GroupPrayListVM.DateSortedItem? = nil,
         groupInfo: GroupInfo?) {
        self.groupRepo = groupRepo
        self.groupInfo = groupInfo
        if let nameItem = nameItem {
            name = nameItem.member.name
            prayTitle = nameItem.member.name + " 기도"
            loadMemberPray(member: nameItem.member)
        } else if let dateItem = dateItem {
            date = dateItem.date
            prayTitle = dateItem.date + " 기도"
            dateItem.prayItemList.forEach { (member: String, pray: String, _ isShowing: Bool) in
                self.dateItem.append((member: member, pray: pray, isShowing: isShowing))
                prayContents += member + "\n"
                prayContents += pray
                prayContents += "\n\n"
            }
        }
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    private func loadMemberPray(member: Member) {
        guard let groupInfo = groupInfo else {
            return
        }

        groupRepo.fetchIndividualPrayList(member: member,
                                          groupID: groupInfo.id,
                                          limit: 20)
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { list in
                Log.w(list)
                list.forEach { item in
                    self.nameItem.append((id: UUID().uuidString,
                                          date: item.date,
                                          pray: item.pray))
                    
                    self.prayContents.append(item.date)
                    self.prayContents.append("\n")
                    self.prayContents.append(item.pray)
                    self.prayContents.append("\n\n\n")
                }
            })
            .store(in: &cancellables)
    }
    
    func editPray() {
        if !nameItem.isEmpty {
            editNameItemPray()
        } else if !dateItem.isEmpty {
            editDateItemPray()
        }
    }
    
    private func editNameItemPray() {
        
    }
    
    private func editDateItemPray() {
        
    }
}

// MARK: - GroupEditPrayVMMock
class GroupEditPrayVMMock: GroupEditPrayVM {
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    init() {
        super.init(groupRepo: GroupRepoMock(), nameItem: nil, dateItem: nil, groupInfo: nil)
        prayTitle = "ghdhghhg"
        prayContents = "asdasdsd asdlkmasld msadk saldkm salk"
        self.nameItem = []
        self.dateItem = []
    }
}
