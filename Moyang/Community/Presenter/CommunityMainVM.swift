//
//  CommunityMainVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import Combine

class CommunityMainVM: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    
    @Published var communityCardListVM = CommunityCardListVM()
    
    init() {
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
}
