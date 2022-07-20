//
//  LogInVM.swift
//  Moyang
//
//  Created by kibo on 2022/07/18.
//

import RxSwift
import RxCocoa
import AuthenticationServices
import GoogleSignIn
import Security

class LogInVM: NSObject, VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: AuthUseCase
    
    let name = BehaviorRelay<String?>(value: nil)
    let birth = BehaviorRelay<String?>(value: nil)
    
    let isAlreadyExist = BehaviorRelay<Void>(value: ())
    let isEmailNotExist = BehaviorRelay<Void>(value: ())
    let credential = BehaviorRelay<String?>(value: nil)
    
    let isLoginSuccess = BehaviorRelay<Void>(value: ())
    let isLoginFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: AuthUseCase) {
        self.useCase = useCase
        super.init()
        bind()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        useCase.credential
            .bind(to: credential)
            .disposed(by: disposeBag)
        
        useCase.isAlreadyExist
            .bind(to: isAlreadyExist)
            .disposed(by: disposeBag)
        
        useCase.isEmailNotExist
            .bind(to: isEmailNotExist)
            .disposed(by: disposeBag)
        
        useCase.isError
            .subscribe(onNext: { error in
                guard let error = error else { return }
                Log.e(error as Any)
            }).disposed(by: disposeBag)
        
        useCase.isLoginSuccess
            .skip(1)
            .bind(to: isLoginSuccess)
            .disposed(by: disposeBag)
        
        useCase.isLoginFailure
            .skip(1)
            .bind(to: isLoginFailure)
            .disposed(by: disposeBag)
    }
    
    private func registerUser() {
        guard let name = name.value, let birth = birth.value else {
            Log.e("No data")
            return
        }
        useCase.registUser(name: name, birth: birth)
    }
    
    func googleSignUp(user: GIDGoogleUser) {
        guard let credential = user.userID,
              let email = user.profile?.email else {
            return
        }
        useCase.appLogin(email: email,
                         credential: credential)
    }
    private func appleSignIn(_ userIdentifier: String, _ name: PersonNameComponents?, _ email: String?) {
        useCase.checkEmailExist(email: email ?? "",
                                credential: userIdentifier, auth: AuthType.apple.rawValue)
    }
}

extension LogInVM {
    struct Input {}
    
    struct Output {
        let isEmailNotExist: Driver<Void>
        
        let isLoginSuccess: Driver<Void>
        let isLoginFailure: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(isEmailNotExist: isEmailNotExist.asDriver(),
                      
                      isLoginSuccess: isLoginSuccess.asDriver(),
                      isLoginFailure: isLoginFailure.asDriver()
        )
    }
}

extension LogInVM: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            var email = appleIDCredential.email
            
            let keychain = KeychainSwift()
            if let email = email {
                keychain.set(email, forKey: "appleEmailKey")
            } else {
                email = keychain.get("appleEmailKey")
            }
            // Register user in fitto server system.
            self.appleSignIn(userIdentifier, fullName, email)
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        Log.e("login error")
    }
}
