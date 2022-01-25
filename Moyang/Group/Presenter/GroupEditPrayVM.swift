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
    
    @Published var nameItem: GroupPrayListVM.NameSortedItem?
    @Published var dateItem: GroupPrayListVM.DateSortedItem?
    @Published var isNameEdit: Bool = false
    @Published var isEditSuccess = false
    
    var maxDisplayedMembers = 5
    
    init(groupRepo: GroupRepo,
         nameItem: GroupPrayListVM.NameSortedItem? = nil,
         dateItem: GroupPrayListVM.DateSortedItem? = nil) {
        self.groupRepo = groupRepo
        if let nameItem = nameItem {
            self.nameItem = nameItem
            self.isNameEdit = true
        } else if let dateItem = dateItem {
            self.dateItem = dateItem
            self.isNameEdit = false
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
