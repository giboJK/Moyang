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
    
    @Published var division = ""
    @Published var name = ""
    @Published var leaderName = ""
    @Published var totalItemList = [AddNewGroupVM.SearchMemberItem]()
    @Published var selectedItemList = [AddNewGroupVM.SearchMemberItem]()
    
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
            } receiveValue: { list in
                self.memberDetailToSearchMemberItem(list: list)
                
            }.store(in: &cancellables)
    }
    
    func memberDetailToSearchMemberItem(list: [MemberDetail]) {
        var itemList = [AddNewGroupVM.SearchMemberItem]()
        list.forEach {
            itemList.append(SearchMemberItem(memberDetail: $0))
        }
        
        totalItemList = itemList
    }
    
    func selectMember() {
        
    }
}

extension AddNewGroupVM {
    struct SearchMemberItem: Identifiable {
        let id: String
        let name: String
        let email: String
        let birth: String
        
        init(memberDetail: MemberDetail) {
            id = memberDetail.id
            name = memberDetail.memberName
            email = memberDetail.email
            birth = memberDetail.birth
        }
    }
}
