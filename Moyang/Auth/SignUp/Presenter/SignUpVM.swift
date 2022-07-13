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
    let useCase: SignUpUseCase
    
    let name = BehaviorRelay<String?>(value: nil)
    let birth = BehaviorRelay<String?>(value: nil)
    
    let isAlreadyExist = BehaviorRelay<Void>(value: ())
    let googleEmailNotExist = BehaviorRelay<Void>(value: ())
    let appleEmailNotExist = BehaviorRelay<Void>(value: ())
    
    init(useCase: SignUpUseCase) {
        self.useCase = useCase
    }
    
    deinit { Log.i(self) }
    
    private func registerUser() {
        //        useCase.registUser(email: email, pw: password, name: name, birth: birth)
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

extension SignUpVM {
    struct Input {
        var google: Driver<Void> = .empty()
        var apple: Driver<Void> = .empty()
        var setName: Driver<String?> = .empty()
        var setBirth: Driver<String?> = .empty()
        var registUser: Driver<Void> = .empty()
    }
    
    struct Output {
        let name: Driver<String?>
        let birth: Driver<String?>
        
        let isAlreadyExist: Driver<Void>
        let googleEmailNotExist: Driver<Void>
        let appleEmailNotExist: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        input.google
            .drive(onNext: { [weak self] _ in
            }).disposed(by: disposeBag)
        input.apple
            .drive(onNext: { [weak self] _ in
            }).disposed(by: disposeBag)
        
        return Output(name: name.asDriver(),
                      birth: birth.asDriver(),
                      isAlreadyExist: isAlreadyExist.asDriver(),
                      googleEmailNotExist: googleEmailNotExist.asDriver(),
                      appleEmailNotExist: appleEmailNotExist.asDriver()
        )
    }
}

extension SignUpVM: ASAuthorizationControllerDelegate {
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
