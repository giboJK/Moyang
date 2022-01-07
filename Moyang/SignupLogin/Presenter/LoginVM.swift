//
//  LoginVM.swift
//  Moyang
//
//  Created by kibo on 2022/01/07.
//

import SwiftUI
import Combine

class LoginVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    init() {
    }
    
    func startLogin() {
        
    }

    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
