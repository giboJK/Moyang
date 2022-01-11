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
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isLoginSuccess: Bool = false
    @Published var loginError: MoyangError?
    
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func signup() {
        
    }
    
    func login() {
        loginService.login(id: id, pw: password)
            .sink { completion in
                Log.i(completion)
            } receiveValue: { isSuccess in
                self.isLoginSuccess = isSuccess
            }.store(in: &cancellables)
    }

    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
