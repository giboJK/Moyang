//
//  IntroVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/17.
//

import SwiftUI
import Combine

class IntroVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var isLoginSuccess: Bool = false
    @Published var isLoadingUserData: Bool = false
    
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
        tryAutoLogin()
    }
    
    deinit { Log.i(self) }
    
    private func tryAutoLogin() {
        if UserData.shared.authType == AuthType.google.rawValue {
            googleLogin()
        } else {
            emailLogin()
        }
    }
    
    private func emailLogin() {
        guard let userID = UserData.shared.userID else { return }
        guard let pw = UserData.shared.password else { return }
        
        self.isLoadingUserData = true
        
        loginService.emailLogin(id: userID, pw: pw)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Log.i(completion)
            } receiveValue: { _ in
                self.fetchUserData(id: userID, type: .email)
            }.store(in: &cancellables)
    }
    
    private func googleLogin() {
        loginService.googleLogin()
            .sink { _ in
                self.isLoadingUserData = true
            } receiveValue: { email in
                self.fetchUserData(id: email.lowercased(), type: .google)
            }.store(in: &cancellables)
    }
    
    private func fetchUserData(id: String, type: AuthType) {
        loginService.fetchUserData(id: id, type: type)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.isLoadingUserData = false
            } receiveValue: { memberDetail in
                UserData.shared.myInfo = memberDetail
                self.isLoginSuccess = true
            }.store(in: &cancellables)
    }
}
