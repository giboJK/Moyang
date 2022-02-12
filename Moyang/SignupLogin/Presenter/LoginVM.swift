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
    private let loginService: LoginService
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isSignupSuccess: Bool = false
    
    @Published var isLoginSuccess: Bool = false
    @Published var isLoadingUserDataFinished: Bool = true
    
    @Published var moveToProfileSetView: Bool = false
    
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
        self.isLoadingUserDataFinished = false
        loginService.login(id: id, pw: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Log.i(completion)
            } receiveValue: { _ in
                self.fetchUserData(id: self.id.lowercased())
            }.store(in: &cancellables)
    }
    
    func findPassword() {
        
    }
    
    func resetData() {
        id = ""
        password = ""
        isSignupSuccess = false
        isLoginSuccess = false
        isLoadingUserDataFinished = true
        moveToProfileSetView = false
    }
    
    private func fetchUserData(id: String) {
        loginService.fetchUserData(id: id)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<MemberDetail, MoyangError> in
                self.isLoadingUserDataFinished = true
                switch error {
                case .noData:
                    self.moveToProfileSetView = true
                case .other:
                    // TODO: 잘못된 정보입니다.
                    Log.e(error)
                default:
                    break
                }
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            .sink { completion in
                self.isLoadingUserDataFinished = true
            } receiveValue: { memberDetail in
                UserData.shared.userID = self.id
                UserData.shared.password = self.password
                UserData.shared.myInfo = memberDetail
                self.isLoginSuccess = true
            }.store(in: &cancellables)
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
