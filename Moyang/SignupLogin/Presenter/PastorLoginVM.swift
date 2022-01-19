//
//  PastorLoginVM.swift
//  Moyang
//
//  Created by kibo on 2022/01/18.
//

import SwiftUI
import Combine

class PastorLoginVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isSignupSuccess: Bool = false
    
    @Published var isLoginSuccess: Bool = false
    @Published var loginError: MoyangError?
    @Published var isLoadingUserData: Bool = false
    
    private var pastorList = [String]()
    
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func login() {
        self.isLoadingUserData = true
        loginService.pastorLogin(id: id, pw: password)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { _ in
                if self.pastorList.contains(self.id.lowercased()) {
                    self.fetchUserData()
                    UserData.shared.userID = self.id
                    UserData.shared.password = self.password
                    UserData.shared.isPastor = true
                } else {
                    self.isLoadingUserData = false
                    Log.e("No user")
                }
            }.store(in: &cancellables)
    }
    
    func fetchPastorList() {
        loginService.fetchPastorList()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { obj in
                self.pastorList = obj.pastors
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
