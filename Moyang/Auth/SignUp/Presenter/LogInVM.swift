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
    
    let isRegisterSuccess = BehaviorRelay<Void>(value: ())
    let isRegisterFailure = BehaviorRelay<Void>(value: ())
    
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
        
        useCase.isRegisterSuccess
            .skip(1)
            .bind(to: isRegisterSuccess)
            .disposed(by: disposeBag)
        
        useCase.isRegisterFailure
            .skip(1)
            .bind(to: isRegisterSuccess)
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
        useCase.checkEmailExist(email: email,
                                credential: credential, auth: AuthType.google.rawValue)
    }
    private func appleSignIn(_ userIdentifier: String, _ name: PersonNameComponents?, _ email: String?) {
        useCase.checkEmailExist(email: email ?? "",
                                credential: userIdentifier, auth: AuthType.apple.rawValue)
    }
}

extension LogInVM {
    struct Input {
        var apple: Driver<Void> = .empty()
        var setName: Driver<String?> = .empty()
        var setBirth: Driver<String?> = .empty()
        var registUser: Driver<Void> = .empty()
    }
    
    struct Output {
        let name: Driver<String?>
        let birth: Driver<String?>
        
        let isAlreadyExist: Driver<Void>
        let isEmailNotExist: Driver<Void>
        
        let isRegisterSuccess: Driver<Void>
        let isRegisterFailure: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        input.apple
            .drive(onNext: { [weak self] _ in
            }).disposed(by: disposeBag)
        
        input.setName
            .drive(onNext: { [weak self] name in
                if let name = name, !(name.first?.isWhitespace ?? false) {
                    self?.name.accept(String(name.prefix(30)))
                }
            }).disposed(by: disposeBag)
        
        input.setBirth
            .drive(birth)
            .disposed(by: disposeBag)
        
        input.registUser
            .drive(onNext: { [weak self] _ in
                self?.registerUser()
            }).disposed(by: disposeBag)
        
        return Output(name: name.asDriver(),
                      birth: birth.asDriver(),
                      isAlreadyExist: isAlreadyExist.asDriver(),
                      isEmailNotExist: isEmailNotExist.asDriver(),
                      
                      isRegisterSuccess: isRegisterSuccess.asDriver(),
                      isRegisterFailure: isRegisterFailure.asDriver()
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
