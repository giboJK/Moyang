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
    @Published var showSortingByMember = true
    @Published var isLeader = false
    
    init(groupRepo: GroupRepo, groupInfo: GroupInfo?) {
        self.groupRepo = groupRepo
        if groupInfo == nil {
            self.groupInfo = UserData.shared.groupInfo
        } else {
            self.groupInfo = groupInfo
        }
        loadData()
        setIsLeader()
    }
    
    deinit { Log.d(self) }
    
    func loadData() {
        guard let groupInfo = groupInfo else { return }
        groupRepo.addGroupPrayListListener(groupInfo: groupInfo)
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { list in
                let groupPrayListItem = GroupPrayListItem(data: list, groupInfo: groupInfo)
                self.dateItemList = groupPrayListItem.dateSortedItemList
            })
            .store(in: &cancellables)
        
        groupInfo.memberList.forEach { member in
            groupRepo.fetchIndividualPrayList(member: member, groupID: groupInfo.id, limit: 1)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let moyangError):
                        let error = moyangError as MoyangError
                        switch error {
                        case .noData:
                            self.nameItemList.append(NameSortedItem(member: member,
                                                                    dateList: [Date().toString("yyyy-MM-dd")],
                                                                    prayList: ["기도제목을 추가해보세요 😊"]))
                        default:
                            break
                        }
                    case .finished:
                        Log.i(completion)
                    }
                }, receiveValue: { list in
                    Log.w(list)
                    if let item = list.first {
                        self.nameItemList.append(NameSortedItem(member: member,
                                                                dateList: [item.date],
                                                                prayList: [item.pray]))
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    func changeSorting() {
        showSortingByMember.toggle()
    }
    
    func setIsLeader() {
        isLeader = groupInfo?.leaderList.contains(where: { member in
            member.id == UserData.shared.myInfo?.id ?? ""
        }) ?? false
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
                nameSorted.append(NameSortedItem(member: member,
                                                 dateList: dateList.reversed(),
                                                 prayList: prayList.reversed()))
            }
            
            var dateSorted = [DateSortedItem]()
            data.forEach {
                dateSorted.append(DateSortedItem(date: $0.date, prayItemList: $0.list))
            }
            
            self.nameSortedItemList = nameSorted.sorted { $0.member.name < $1.member.name }
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
        let member: Member
        var prayItemList: [(date: String, pray: String)]
        
        init(member: Member, dateList: [String], prayList: [String]) {
            self.id = member.id
            self.member = member
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
        
        func makeContents() -> (id: String, title: String, pray: String) {
            let title = "\(date) 기도"
            var prayContents = ""
            prayItemList.forEach { (member: String, pray: String, _ isShowing: Bool) in
                prayContents += member + "\n"
                prayContents += pray
                prayContents += "\n\n"
            }
            return (date, title, prayContents)
        }
    }
}
