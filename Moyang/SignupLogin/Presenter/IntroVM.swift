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
    }
    
    deinit { Log.i(self) }
    
    func tryAutoLogin() {
        guard let userID = UserData.shared.userID else { return }
        guard let pw = UserData.shared.password else { return }
        self.isLoadingUserData = true
        
        loginService.login(id: userID, pw: pw)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Log.i(completion)
            } receiveValue: { isSuccess in
                self.fetchUserData()
                self.isLoginSuccess = isSuccess
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
}
