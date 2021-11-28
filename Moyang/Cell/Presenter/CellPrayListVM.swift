//
//  CellPrayListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Foundation

class CellPrayListVM: ObservableObject, Identifiable {
    @Published var items = [MemberPrayItem]()
    
    init() {
        items = CellPrayListItem(cellPray: DummyData().cellPray).list
    }
}

extension CellPrayListVM {
    typealias Identifier = Int
    struct CellPrayListItem: Hashable {
        let id: Identifier
        let cellName: String
        let list: [MemberPrayItem]
        
        init(cellPray: CellPray) {
            self.id = cellPray.id
            self.cellName = cellPray.cellName
            
            var prayList = [MemberPrayItem]()
            for i in 0 ..< min(cellPray.memberList.count, cellPray.prayList.count) {
                prayList.append(MemberPrayItem(name: cellPray.memberList[i],
                                               pray: cellPray.prayList[i]))
            }
            self.list = prayList
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: CellPrayListVM.CellPrayListItem, rhs: CellPrayListVM.CellPrayListItem) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    struct MemberPrayItem {
        let name: String
        let pray: String
        init(name: String, pray: String) {
            self.name = name
            self.pray = pray
        }
    }
}
