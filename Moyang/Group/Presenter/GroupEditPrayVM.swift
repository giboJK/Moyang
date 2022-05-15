//
//  GroupEditPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/25.
//

import SwiftUI
import Combine

class GroupEditPrayVM: ObservableObject {
    let groupRepo: GroupRepo
    var cancellables = Set<AnyCancellable>()
    var groupInfo: GroupInfo?
    var memberID: String = ""
    var dateItemList: [GroupPrayListVM.DateSortedItem] = []
    
    @Published var nameItem = [NameItem]()
    @Published var dateItem = [DateItem]()
    @Published var isEditSuccess = false
    
    @Published var prayTitle = ""
    @Published var prayContents = ""
    @Published var date = ""
    @Published var name = ""
    
    init(groupRepo: GroupRepo,
         nameItem: GroupPrayListVM.NameSortedItem? = nil,
         dateItem: GroupPrayListVM.DateSortedItem? = nil,
         dateItemList: [GroupPrayListVM.DateSortedItem] = [],
         groupInfo: GroupInfo?) {
        self.groupRepo = groupRepo
        self.groupInfo = groupInfo
        if let nameItem = nameItem {
            memberID = nameItem.member.id
            name = nameItem.member.name
            prayTitle = nameItem.member.name + " 기도"
            loadMemberPray(member: nameItem.member)
        } else if let dateItem = dateItem {
            self.dateItemList = dateItemList
            date = dateItem.date
            prayTitle = dateItem.date + " 기도"
            dateItem.prayItemList.forEach { (member: String, pray: String, _ isShowing: Bool) in
                self.dateItem.append(DateItem(member: member, pray: pray))
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
                    self.nameItem.append(NameItem(date: item.date,
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


extension GroupEditPrayVM {
    struct NameItem: Identifiable {
        let id: String
        let date: String
        let pray: String
        
        init(date: String, pray: String) {
            id = UUID().uuidString
            self.date = date
            self.pray = pray
        }
    }
    
    struct DateItem: Identifiable {
        let id: String
        let member: String
        let pray: String
        
        init(member: String, pray: String) {
            id = UUID().uuidString
            self.member = member
            self.pray = pray
        }
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
