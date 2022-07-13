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
    }
    
    func fetchPastorList() {
    }
    
    func findPassword() {
        
    }
    
    private func fetchUserData(id: String) {
    }

    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
