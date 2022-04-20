//
//  GroupPrayListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Combine
import Foundation

class GroupPrayListVM: ObservableObject, Identifiable {
    let groupRepo: GroupRepo
    var cancellables: Set<AnyCancellable> = []
    var groupInfo: GroupInfo?
    
    @Published var nameItemList = [NameSortedItem]()
    @Published var dateItemList = [DateSortedItem]()
    @Published var showSortingByName = true
    
    init(groupRepo: GroupRepo, groupInfo: GroupInfo?) {
        self.groupRepo = groupRepo
        if groupInfo == nil {
            self.groupInfo = UserData.shared.groupInfo
        } else {
            self.groupInfo = groupInfo
        }
        loadData()
    }
    
    deinit { Log.d(self) }
    
    func loadData() {
        guard let groupInfo = groupInfo else { return }
        groupRepo.addGroupPrayListListener(groupInfo: groupInfo)
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { list in
                let groupPrayListItem = GroupPrayListItem(data: list, groupInfo: groupInfo)
                self.nameItemList = groupPrayListItem.nameSortedItemList
                self.dateItemList = groupPrayListItem.dateSortedItemList
            })
            .store(in: &cancellables)
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
    struct GroupPrayListItem: Hashable {
        let id: Identifier
        let groupName: String
        let nameSortedItemList: [NameSortedItem]
        let dateSortedItemList: [DateSortedItem]
        
        private let groupMemberPrayList: [GroupMemberPrayList]
        
        init(data: [GroupMemberPrayList], groupInfo: GroupInfo) {
            id = groupInfo.id
            groupName = groupInfo.groupName
            self.groupMemberPrayList = data
            
            var nameSorted = [NameSortedItem]()
            
            groupInfo.memberList.forEach { member in
                var dateList = [String]()
                var prayList = [String]()
                data.forEach {
                    if let pray = $0.list.first(where: { pray in
                        pray.member.name == member.name
                    }) {
                        dateList.append($0.date)
                        prayList.append(pray.pray)
                    }
                }
                nameSorted.append(NameSortedItem(id: member.id,
                                                 name: member.name,
                                                 dateList: dateList.reversed(),
                                                 prayList: prayList.reversed()))
            }
            
            var dateSorted = [DateSortedItem]()
            data.forEach {
                dateSorted.append(DateSortedItem(date: $0.date, prayItemList: $0.list))
            }
            
            self.nameSortedItemList = nameSorted.sorted { $0.name < $1.name }
            self.dateSortedItemList = dateSorted.sorted { $0.date > $1.date }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: GroupPrayListVM.GroupPrayListItem, rhs: GroupPrayListVM.GroupPrayListItem) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    struct NameSortedItem: Identifiable {
        let id: String
        let name: String
        var prayItemList: [(date: String, pray: String)]
        
        init(id: String, name: String, dateList: [String], prayList: [String]) {
            self.id = id
            self.name = name
            var newPrayItemList = [(String, String)]()
            for i in 0 ..< dateList.count where !prayList[i].isEmpty {
                newPrayItemList.append((dateList[i], prayList[i]))
            }
            self.prayItemList = newPrayItemList
        }
    }
    
    struct DateSortedItem {
        let date: String
        var prayItemList: [(member: String, pray: String, isShowing: Bool)]
        var count: Int
        
        init(date: String, prayItemList: [GroupMemberPray]) {
            self.date = date
            var newPrayItemList = [(String, String, Bool)]()
            self.count = 0
            for i in 0 ..< prayItemList.count {
                newPrayItemList.append((prayItemList[i].member.name, prayItemList[i].pray, true))
                if !prayItemList[i].pray.isEmpty {
                    count += 1
                }
            }
            self.prayItemList = newPrayItemList
        }
    }
}
