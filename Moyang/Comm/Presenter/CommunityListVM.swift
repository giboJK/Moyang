//
//  CommunityListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/04/05.
//

import SwiftUI
import Combine

class CommunityListVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var church: String = ""
    @Published var itemList: [GroupInfo] = []
    
    init() {
        fetchCommunityList()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    private func fetchCommunityList() {
//        church = churchInfo.name
//        
//        groupRepo.fetchGroupInfoList(groupList: groupList)
//            .sink { completion in
//                Log.d(completion)
//            } receiveValue: { [weak self] list in
//                Log.d(list)
//                self?.itemList = list
//            }.store(in: &cancellables)
    }
}
