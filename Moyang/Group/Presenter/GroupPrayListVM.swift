//
//  GroupPrayListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Combine
import Foundation

class GroupPrayListVM: ObservableObject, Identifiable {
    @Published var nameSorteditemList = [NameSortedMemberPrayItem]()
    @Published var dateSorteditemList = [DateSortedMemberPrayItem]()
    @Published var showSortingByName = true
    
    private let groupRepo: GroupRepo
    
    init(groupRepo: GroupRepo) {
        self.groupRepo = groupRepo
        loadData()
    }
    
    func loadData() {
    }
    
    func changeSorting() {
        showSortingByName.toggle()
    }
    
    func editNamePray() {
        
    }
    
    func editDatePray() {
        
    }
}

extension GroupPrayListVM {
    typealias Identifier = String
    struct CellPrayListItem: Hashable {
        let id: Identifier
        let groupName: String
        let nameSortedItemList: [NameSortedMemberPrayItem]
        let dateSortedItemList: [DateSortedMemberPrayItem]
        
        init(member: [GroupMember]) {
            id = ""
            groupName = ""
            self.nameSortedItemList = []
            self.dateSortedItemList = []
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: GroupPrayListVM.CellPrayListItem, rhs: GroupPrayListVM.CellPrayListItem) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    struct NameSortedMemberPrayItem {
        let name: String
        let prayItemList: [(date: String, pray: String)]
        
        init(name: String, dateList: [String], prayList: [String]) {
            self.name = name
            var newPrayItemList = [(String, String)]()
            for i in 0 ..< dateList.count {
                newPrayItemList.append((dateList[i], prayList[i]))
            }
            self.prayItemList = newPrayItemList
        }
    }
    
    struct DateSortedMemberPrayItem {
        let date: String
        let prayItemList: [(member: String, pray: String)]
        
        init(date: String, prayItemList: [GroupMemberPray]) {
            self.date = date
            var newPrayItemList = [(String, String)]()
            for i in 0 ..< prayItemList.count {
                newPrayItemList.append((prayItemList[i].memberName, prayItemList[i].pray))
            }
            self.prayItemList = newPrayItemList
        }
    }
}
