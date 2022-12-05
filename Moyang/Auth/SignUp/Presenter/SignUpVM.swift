//
//  SignUpVM.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import RxSwift
import RxCocoa
import AuthenticationServices
import GoogleSignIn
import Security

class SignUpVM: NSObject, VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: AuthUseCase
    
    let isAlreadyExist = BehaviorRelay<Void>(value: ())
    let credential = BehaviorRelay<String?>(value: nil)
    
    let isRegisterSuccess = BehaviorRelay<Void>(value: ())
    let isRegisterFailure = BehaviorRelay<Void>(value: ())
    
    let nameToRegister = BehaviorRelay<String>(value: "")
    let emailToRegister = BehaviorRelay<String?>(value: "")
    
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
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.registerUser()
            }).disposed(by: disposeBag)
        
        useCase.isError
            .subscribe(onNext: { error in
                guard let error = error else { return }
                Log.e(error as Any)
            }).disposed(by: disposeBag)
        
        useCase.isRegisterSuccess
            .skip(1)
            .bind(to: isRegisterSuccess)
            .disposed(by: disposeBag)
        
        useCase.isRegisterFailure
            .skip(1)
            .bind(to: isRegisterFailure)
            .disposed(by: disposeBag)
    }
    
    private func registerUser() {
        if emailToRegister.value != nil {
            useCase.registUser(name: nameToRegister.value)
        } else {
            isRegisterFailure.accept(())
        }
    }
    
    func googleSignUp(user: GIDGoogleUser) {
        guard let credential = user.userID,
              let email = user.profile?.email else {
            return
        }
        nameToRegister.accept(user.profile?.name ?? "") 
        useCase.checkEmailExist(email: email,
                                credential: credential, auth: AuthType.google.rawValue)
    }
    private func appleSignIn(_ userIdentifier: String, _ name: PersonNameComponents?, _ email: String?) {
        if let email = email {
            useCase.checkEmailExist(email: email,
                                    credential: userIdentifier, auth: AuthType.apple.rawValue)
        } else {
            isRegisterFailure.accept(())
        }
    }
}

extension SignUpVM {
    struct Input {
        var apple: Driver<Void> = .empty()
        var registUser: Driver<Void> = .empty()
    }
    
    struct Output {
        let isAlreadyExist: Driver<Void>
        
        let isRegisterSuccess: Driver<Void>
        let isRegisterFailure: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        input.registUser
            .drive(onNext: { [weak self] _ in
                self?.registerUser()
            }).disposed(by: disposeBag)
        
        return Output(isAlreadyExist: isAlreadyExist.asDriver(),
                      
                      isRegisterSuccess: isRegisterSuccess.asDriver(),
                      isRegisterFailure: isRegisterFailure.asDriver()
        )
    }
}

extension SignUpVM: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let keychain = KeychainSwift()
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let formatter = PersonNameComponentsFormatter()
            formatter.style = .default
            if let fullName = appleIDCredential.fullName {
                let nameStr = formatter.string(from: fullName)
                if nameStr.isEmpty, let keychainName = keychain.get("MoyangAppleNameKey") {
                    nameToRegister.accept(keychainName)
                } else {
                    nameToRegister.accept(nameStr)
                    keychain.set(nameStr, forKey: "MoyangAppleNameKey")
                }
            }
            var email = appleIDCredential.email
            
            if let email = email {
                keychain.set(email, forKey: "MoyangAppleEmailKey")
            } else {
                email = keychain.get("MoyangAppleEmailKey")
            }
            emailToRegister.accept(email)
            // Register user in fitto server system.
            self.appleSignIn(userIdentifier, appleIDCredential.fullName, email)
            
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
