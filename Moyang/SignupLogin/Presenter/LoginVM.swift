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
    @Published var isSignupSuccess: Bool = false
    
    @Published var isLoginSuccess: Bool = false
    @Published var loginError: MoyangError?
    @Published var isLoadingUserData: Bool = false
    
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func signup() {
        loginService.signup(id: id, pw: password)
            .sink { completion in
                Log.i(completion)
            } receiveValue: { isSuccess in
                self.isSignupSuccess = isSuccess
            }.store(in: &cancellables)
    }
    
    func login() {
        self.isLoadingUserData = true
        loginService.login(id: id, pw: password)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { _ in
                self.fetchUserData()
            }.store(in: &cancellables)
    }
    
    private func fetchUserData() {
        loginService.fetchUserData()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.isLoadingUserData = false
            } receiveValue: { memberDetail in
                UserData.shared.myInfo = memberDetail
                self.isLoginSuccess = true
            }.store(in: &cancellables)
    }

    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
