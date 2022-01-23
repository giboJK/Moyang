//
//  ProfileVM.swift
//  Moyang
//
//  Created by kibo on 2022/01/24.
//

import SwiftUI
import Combine

class ProfileVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var groupInfoItem: UserItem = UserItem()
    
    init() {
        
    }
}

extension ProfileVM {
    struct UserItem {
        var name: String = ""
        
        init() {
            
        }
        
        init(name: String) {
            self.name = name
        }
    }
}
