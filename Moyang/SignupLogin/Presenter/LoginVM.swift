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
    private let loginService: LoginService = FirestoreLoginServiceImpl(service: FirestoreServiceImpl())
    
    @Published var id: String = ""
    @Published var password: String = ""
    
    @Published var isLoadingUserDataFinished: Bool = true
    
    @Published var moveToProfileSetView: Bool = false
    
    @Published var isSignupSuccess: Bool = false
    var signupTitle: String = "회원가입 이메일 발송"
    var signupMessage: String = "이메일을 확인해주세요"
    
    @Published var isLoginSuccess: Bool = false
    @Published var showInvalidPWPopUp: Bool = false
    var errorTitle: String = "로그인 오류"
    var errorMessage: String = ""
    
    init() {
    }
    
    func signup() {
        loginService.signup(id: id, pw: password, type: .email)
            .sink { completion in
                Log.i(completion)
            } receiveValue: { isSuccess in
                self.isSignupSuccess = isSuccess
            }.store(in: &cancellables)
    }
    
    func login() {
        self.isLoadingUserDataFinished = false
        loginService.login(id: id, pw: password, type: .email)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    switch error {
                    case .passwordInvalid:
                        self.showInvalidPWPopUp = true
                        self.errorMessage = "유효하지 않은 비밀번호입니다"
                    case .noUser:
                        self.showInvalidPWPopUp = true
                        self.errorMessage = "등록되지 않은 사용자입니다"
                    case .notVerified:
                        self.showInvalidPWPopUp = true
                        self.errorMessage = "인증되지 않은 사용자입니다. 인증 메일을 확인해주세요."
                    default:
                        Log.i(completion)
                    }
                case .finished:
                    break
                }
                self.isLoadingUserDataFinished = true
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
        loginService.fetchUserData(id: id, type: .email)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<MemberDetail, MoyangError> in
                self.isLoadingUserDataFinished = true
                switch error {
                case .noData:
                    self.moveToProfileSetView = true
                default:
                    Log.e(error)
                }
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            .sink { _ in
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
