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
    
    func loadUserData() {
        if let myInfo = UserData.shared.myInfo {
            groupInfoItem = UserItem(userInfo: myInfo)
        }
    }
}

extension ProfileVM {
    struct UserItem {
        var name: String = ""
        var email: String = ""
        
        init() { }
        
        init(userInfo: MemberDetail) {
            self.name = userInfo.memberName
            self.email = userInfo.email
        }
    }
}
