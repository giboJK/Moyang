//
//  AddNewGroupVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI
import Combine

class AddNewGroupVM: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    private let repo = MemberRepoImpl(service: FirestoreServiceImpl())
    private let groupRepo = GroupRepoImpl(service: FirestoreServiceImpl())
    
    
    @Published var division = ""
    @Published var name = ""
    @Published var leaderListName = ""
    @Published var memberListName = ""
    @Published var memberItemList = [AddNewGroupVM.SearchMemberItem]()
    @Published var leaderItemList = [AddNewGroupVM.SearchMemberItem]()
    @Published var divisionList = ["청년부", "고등부"]
    
    private let youthID = "DFEB77B8-2578-4909-ADBB-175890BDAA4F"
    private let highID = "DAB794ED-01E6-4B68-9ED8-29DA932E5A31"
    
    @Published var selectedIndex: Int?
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    
    var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    var leaderCount = 0
    var memberCount = 0
    
    @Published var keyword = ""
    
    init() {
        fetchMemberList()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func fetchMemberList() {
        repo.fetchMemberList()
            .sink { completion in
                Log.d(completion)
            } receiveValue: { [weak self] list in
                self?.memberDetailToSearchMemberItem(list: list)
                
            }.store(in: &cancellables)
    }
    
    func memberDetailToSearchMemberItem(list: [MemberDetail]) {
        var itemList = [AddNewGroupVM.SearchMemberItem]()
        list.forEach {
            itemList.append(SearchMemberItem(memberDetail: $0))
        }
        
        self.memberItemList = itemList
        self.leaderItemList = itemList
    }
    
    func toggleLeaderSelection(item: SearchMemberItem) {
        if let index = leaderItemList.firstIndex(where: { $0.id == item.id }) {
            leaderItemList[index].isLeader = !leaderItemList[index].isLeader
            leaderItemList[index].isMember = false
        }
        leaderCount = leaderItemList
            .filter { $0.isLeader }.count
        leaderListName = String(leaderItemList
                                    .filter { $0.isLeader }
                                    .map { $0.name }
                                    .reduce("") { $0 + ", " + $1 }
                                    .dropFirst(2))
    }
    
    func toggleMemberSelection(item: SearchMemberItem) {
        if let index = memberItemList.firstIndex(where: { $0.id == item.id }) {
            memberItemList[index].isMember = !memberItemList[index].isMember
            leaderItemList[index].isLeader = false
        }
        memberCount = memberItemList
            .filter { $0.isMember }.count
        memberListName = String(memberItemList
                                    .filter { $0.isLeader }
                                    .map { $0.name }
                                    .reduce("") { $0 + ", " + $1 }
                                    .dropFirst(2))
    }
    
    func addNewGroup() {
        var leaderList = [Member]()
        leaderItemList.filter { $0.isLeader == true }.forEach { item in
            leaderList.append(Member(id: item.id,
                                     name: item.name,
                                     profileURL: ""))
        }
        
        var memberList = [Member]()
        memberItemList.filter { $0.isMember == true }.forEach { item in
            memberList.append(Member(id: item.id,
                                     name: item.name,
                                     profileURL: ""))
        }
        
        let parentGroup = selectedIndex! == 0 ? youthID : highID
        let groupInfo = GroupInfo(id: UUID().uuidString,
                                  createdDate: Date().toString("yyyy.MM.dd"),
                                  groupName: name,
                                  parentGroup: parentGroup,
                                  leaderList: leaderList,
                                  memberList: memberList)
        
        groupRepo.addNewGroup(groupInfo: groupInfo)
            .sink { completion in
                Log.d(completion)
            } receiveValue: { _ in
                self.shouldDismissView = true
            }.store(in: &cancellables)

    }
}

extension AddNewGroupVM {
    struct SearchMemberItem: Identifiable, Hashable {
        let id: String
        let name: String
        let email: String
        let birth: String
        var isSelected: Bool = false
        var isLeader: Bool = false
        var isMember: Bool = false
        
        init(memberDetail: MemberDetail) {
            id = memberDetail.id
            name = memberDetail.memberName
            email = memberDetail.email
            birth = memberDetail.birth
        }
    }
}
