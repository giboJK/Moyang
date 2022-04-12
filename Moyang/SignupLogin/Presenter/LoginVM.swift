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
    private let loginService: LoginService = FSLoginService(service: FSServiceImpl())
    
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
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func signup() {
        loginService.signup(id: id, pw: password, type: .email)
            .sink { completion in
                Log.i(completion)
            } receiveValue: { isSuccess in
                self.isSignupSuccess = isSuccess
            }.store(in: &cancellables)
    }
    
    func emailLogin() {
        self.isLoadingUserDataFinished = false
        loginService.emailLogin(id: id, pw: password)
            .sink { completion in
                self.isLoadingUserDataFinished = true
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
            } receiveValue: { _ in
                self.setUserAuthAndEmail(type: .email, email: self.id.lowercased())
                self.fetchUserData(id: self.id.lowercased())
            }.store(in: &cancellables)
    }
    
    func googleLogin() {
        isLoadingUserDataFinished = false
        loginService.googleLogin()
            .sink { _ in
                self.isLoadingUserDataFinished = true
            } receiveValue: { email in
                self.setUserAuthAndEmail(type: .google, email: email.lowercased())
                self.fetchUserData(id: email.lowercased())
            }.store(in: &cancellables)
    }
    
    
    private func setUserAuthAndEmail(type: AuthType, email: String) {
        isLoadingUserDataFinished = true
        UserData.shared.authType = type.rawValue
        UserData.shared.userID = email
    }
    
    private func fetchUserData(id: String) {
        guard let authTypeStr = UserData.shared.authType,
              let authType = AuthType(rawValue: authTypeStr) else { Log.e("Auth type error") ;return }
        
        loginService.fetchUserData(id: id, type: authType)
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
            } receiveValue: { memberDetail in
                UserData.shared.userID = self.id
                UserData.shared.password = self.password
                UserData.shared.myInfo = memberDetail
                self.isLoginSuccess = true
            }.store(in: &cancellables)
    }
    
    func findPassword() {
        
    }
}
