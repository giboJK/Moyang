//
//  CellPrayListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Combine
import Foundation

class CellPrayListVM: ObservableObject, Identifiable {
    @Published var nameSorteditemList = [NameSortedMemberPrayItem]()
    @Published var dateSorteditemList = [DateSortedMemberPrayItem]()
    @Published var showSortingByName = true
    
    private let cellRepo: CellRepo
    
    init(cellRepo: CellRepo) {
        self.cellRepo = cellRepo
        loadData()
    }
    
    func loadData() {
        let cellPrayListItem = CellPrayListItem(data: DummyData().cellPrayInfo,
                                                member: DummyData().cellInfo.memberList)
        nameSorteditemList = cellPrayListItem.nameSortedItemList
        dateSorteditemList = cellPrayListItem.dateSortedItemList
    }
    
    func changeSorting() {
        showSortingByName.toggle()
    }
    
    func editNamePray() {
        
    }
    
    func editDatePray() {
        
    }
}

extension CellPrayListVM {
    typealias Identifier = String
    struct CellPrayListItem: Hashable {
        let id: Identifier
        let cellName: String
        let nameSortedItemList: [NameSortedMemberPrayItem]
        let dateSortedItemList: [DateSortedMemberPrayItem]
        
        init(data: CellPrayInfo, member: [CellMember]) {
            self.id = data.id
            self.cellName = data.cellName
            
            var nameSorted = [NameSortedMemberPrayItem]()
            var dateSorted = [DateSortedMemberPrayItem]()
            for i in 0 ..< data.cellPrayList.count {
                dateSorted.append(DateSortedMemberPrayItem(date: data.cellPrayList[i].dateString,
                                                           prayItemList: data.cellPrayList[i].memberPrayList))
            }
            
            for i in 0 ..< member.count {
                var dateList = [String]()
                var prayList = [String]()
                for j in 0 ..< data.cellPrayList.count {
                    if let memberPray = data.cellPrayList[j].memberPrayList.first { $0.memberName == member[i].name } {
                        dateList.append(data.cellPrayList[j].dateString)
                        prayList.append(memberPray.pray)
                    }
                }
                
                nameSorted.append(NameSortedMemberPrayItem(name: member[i].name,
                                                           dateList: dateList, prayList: prayList))
            }
            
            self.nameSortedItemList = nameSorted.sorted { $0.name < $1.name }
            self.dateSortedItemList = dateSorted.sorted { $0.date > $1.date }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: CellPrayListVM.CellPrayListItem, rhs: CellPrayListVM.CellPrayListItem) -> Bool {
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
        
        init(date: String, prayItemList: [CellMemberPray]) {
            self.date = date
            var newPrayItemList = [(String, String)]()
            for i in 0 ..< prayItemList.count {
                newPrayItemList.append((prayItemList[i].memberName, prayItemList[i].pray))
            }
            self.prayItemList = newPrayItemList
        }
    }
}
