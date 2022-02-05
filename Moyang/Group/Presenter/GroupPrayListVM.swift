//
//  GroupPrayListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import Combine
import Foundation

class GroupPrayListVM: ObservableObject, Identifiable {
    private let groupRepo: GroupRepo
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var nameItemList = [NameSortedItem]()
    @Published var dateItemList = [DateSortedItem]()
    @Published var showSortingByName = true
    
    init(groupRepo: GroupRepo) {
        self.groupRepo = groupRepo
    }
    
    deinit { Log.d(self) }
    
    func loadData() {
        guard let groupInfo = UserData.shared.groupInfo else { return }
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
                nameSorted.append(NameSortedItem(name: member.name,
                                                 dateList: dateList,
                                                 prayList: prayList))
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
    
    struct NameSortedItem {
        let name: String
        var prayItemList: [(date: String, pray: String)]
        
        init(name: String, dateList: [String], prayList: [String]) {
            self.name = name
            var newPrayItemList = [(String, String)]()
            for i in 0 ..< dateList.count {
                newPrayItemList.append((dateList[i], prayList[i]))
            }
            self.prayItemList = newPrayItemList
        }
    }
    
    struct DateSortedItem {
        let date: String
        var prayItemList: [(member: String, pray: String)]
        
        init(date: String, prayItemList: [GroupMemberPray]) {
            self.date = date
            var newPrayItemList = [(String, String)]()
            for i in 0 ..< prayItemList.count {
                newPrayItemList.append((prayItemList[i].member.name, prayItemList[i].pray))
            }
            self.prayItemList = newPrayItemList
        }
    }
}
