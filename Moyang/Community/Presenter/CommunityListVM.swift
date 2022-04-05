//
//  CommunityListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/04/05.
//

import SwiftUI
import Combine

class CommunityListVM: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    
    @Published var church: String = ""
    @Published var itemList: [CommunityListItem] = []
    
    init() {
        fetchCommunityList()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    private func fetchCommunityList() {
        guard let groupInfo = UserData.shared.groupInfo else {
            return
        }
        
        
    }
}

extension CommunityListVM {
    typealias Identifier = String
    struct CommunityListItem: Identifiable {
        let id: Identifier
        let name: String
        
        init(id: String, name: String
        ) {
            self.id = id
            self.name = name
        }
    }
}
