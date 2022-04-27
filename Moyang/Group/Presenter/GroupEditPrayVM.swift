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
    
    @Published var nameItem: GroupPrayListVM.NameSortedItem!
    @Published var dateItem: GroupPrayListVM.DateSortedItem!
    @Published var isEditSuccess = false
    
    @Published var prayTitle = ""
    @Published var prayContents = ""
    
    var maxDisplayedMembers = 5
    
    init(groupRepo: GroupRepo,
         nameItem: GroupPrayListVM.NameSortedItem? = nil,
         dateItem: GroupPrayListVM.DateSortedItem? = nil) {
        self.groupRepo = groupRepo
        if let nameItem = nameItem {
            self.nameItem = nameItem
            prayTitle = nameItem.name + " 기도"
            nameItem.prayItemList.forEach { (dateString: String, pray: String) in
                if let date = dateString.toDate("yyyy-MM-dd HH:mm:ss") {
                    let fixedDateString = date.toString("yyyy-MM-dd")
                    prayContents += fixedDateString + "\n"
                    prayContents += pray
                    prayContents += "\n\n"
                }
            }
        } else if let dateItem = dateItem {
            self.dateItem = dateItem
            prayTitle = dateItem.date + " 기도"
            
            dateItem.prayItemList.forEach { (member: String, pray: String, _ isShowing: Bool) in
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
    
    private func loadMemberPray() {
        
    }
    
    func editPray() {
        if nameItem != nil {
            editNameItemPray()
        } else if dateItem != nil {
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
        super.init(groupRepo: GroupRepoMock(), nameItem: nil, dateItem: nil)
        prayTitle = "ghdhghhg"
        prayContents = "asdasdsd asdlkmasld msadk saldkm salk"
        randomData()
    }
    
    func randomData() {
        let memberA = Member(id: UUID().uuidString,
                             name: "asd",
                             email: "test@test.com",
                             profileURL: "",
                             auth: "EMAIL")
        self.nameItem = GroupPrayListVM.NameSortedItem(member: memberA,
                                                       dateList: [Date().toString("yyyy-MM-dd")],
                                                       prayList: ["rlrlrl eheheh"])
        self.dateItem = GroupPrayListVM.DateSortedItem(date: Date().toString("yyyy-MM-dd"),
                                                       prayItemList: [GroupMemberPray(member: memberA,
                                                                                      pray: "ass asldksad ksalmd")])
    }
}
