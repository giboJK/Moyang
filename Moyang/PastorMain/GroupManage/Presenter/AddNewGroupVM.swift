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
    
    @Published var division = ""
    @Published var name = ""
    @Published var leaderListName = ""
    @Published var memberListName = ""
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
    }
    
    func memberDetailToSearchMemberItem() {
    }
    
    func toggleLeaderSelection() {
    }
    
    func addNewGroup() {
    }
}

extension AddNewGroupVM {
//    struct SearchMemberItem: Identifiable, Hashable {
//        let id: String
//        let name: String
//        let email: String
//        let birth: String
//        let auth: String
//        var isSelected: Bool = false
//        var isLeader: Bool = false
//        var isMember: Bool = false
//
//        init() {
//            id = memberDetail.id
//            name = memberDetail.memberName
//            email = memberDetail.email
//            birth = memberDetail.birth
//            auth = memberDetail.authType
//        }
//    }
}
