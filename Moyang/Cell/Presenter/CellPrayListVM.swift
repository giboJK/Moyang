//
//  CellPrayListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Combine

class CellPrayListVM: ObservableObject, Identifiable {
    @Published var nameSorteditemList = [NameSortedMemberPrayItem]()
    @Published var dateSorteditemList = [DateSortedMemberPrayItem]()
    @Published var showSortingByName = true
    
    init() {
        loadData()
    }
    
    func loadData() {
        let cellPrayListItem = CellPrayListItem(data: DummyData().cellPrayInfo)
        nameSorteditemList = cellPrayListItem.nameSortedItemList
        dateSorteditemList = cellPrayListItem.dateSortedItemList
    }
    
    func changeSorting() {
        showSortingByName.toggle()
    }
}

extension CellPrayListVM {
    typealias Identifier = Int
    struct CellPrayListItem: Hashable {
        let id: Identifier
        let cellName: String
        let nameSortedItemList: [NameSortedMemberPrayItem]
        let dateSortedItemList: [DateSortedMemberPrayItem]
        
        init(data: CellPrayInfo) {
            self.id = data.id
            self.cellName = data.cellName
            
            var nameSorted = [NameSortedMemberPrayItem]()
            var dateSorted = [DateSortedMemberPrayItem]()
            for i in 0 ..< data.cellPrayList.count {
                dateSorted.append(DateSortedMemberPrayItem(date: data.cellPrayList[i].dateString,
                                                           memberList: data.cellPrayList[i].memberList,
                                                           prayList: data.cellPrayList[i].prayList))
            }
            
            if let firstItem = data.cellPrayList.first {
                for i in 0 ..< firstItem.memberList.count {
                    var dateList = [String]()
                    var prayList = [String]()
                    data.cellPrayList.forEach { listItem in
                        dateList.append(listItem.dateString)
                        prayList.append(listItem.prayList[i])
                    }
                    nameSorted.append(NameSortedMemberPrayItem(name: firstItem.memberList[i],
                                                               dateList: dateList,
                                                               prayList: prayList))
                }
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
        let dateList: [String]
        let prayList: [String]
        
        init(name: String, dateList: [String], prayList: [String]) {
            self.name = name
            self.dateList = dateList
            self.prayList = prayList
        }
    }
    
    struct DateSortedMemberPrayItem {
        let date: String
        let memberList: [String]
        let prayList: [String]
        
        init(date: String, memberList: [String], prayList: [String]) {
            self.date = date
            self.memberList = memberList
            self.prayList = prayList
        }
    }
}
