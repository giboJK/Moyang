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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var nameItem: GroupPrayListVM.NameSortedItem!
    @Published var dateItem: GroupPrayListVM.DateSortedItem!
    @Published var isNameEdit: Bool = false
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
            self.isNameEdit = true
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
            self.isNameEdit = false
            prayTitle = dateItem.date + " 기도"
            
            dateItem.prayItemList.forEach { (member: String, pray: String) in
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
