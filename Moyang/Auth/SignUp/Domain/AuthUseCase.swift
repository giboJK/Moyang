//
//  AuthUseCase.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation
import RxSwift
import RxCocoa

class AuthUseCase: UseCase {
    // MARK: - Properties
    let repo: AuthRepo
    
    // MARK: - Rx
    let isAlreadyExist = BehaviorRelay<Void>(value: ())
    let isEmailNotExist = BehaviorRelay<Void>(value: ())
    let isError = BehaviorRelay<Error?>(value: nil)
    
    let email = BehaviorRelay<String?>(value: nil)
    let name = BehaviorRelay<String?>(value: nil)
    let credential = BehaviorRelay<String?>(value: nil)
    let authType = BehaviorRelay<String?>(value: nil)
    
    let isRegisterSuccess = BehaviorRelay<Void>(value: ())
    let isRegisterFailure = BehaviorRelay<Void>(value: ())
    
    let isLoginSuccess = BehaviorRelay<Void>(value: ())
    let isLoginFailure = BehaviorRelay<Void>(value: ())
    
    let versionInfo = BehaviorRelay<AppVersionInfo?>(value: nil)
    
    // MARK: - Lifecycle
    init(repo: AuthRepo) {
        self.repo = repo
        
        super.init()
    }
    
    func checkAppVersion() {
        repo.checkAppVersion { [weak self] result in
            switch result {
            case .success(let response):
                Log.d(response)
                self?.versionInfo.accept(response)
            case .failure(let error):
                Log.e(error)
            }
        }
    }

    func checkEmailExist(email: String, credential: String, auth: String) {
        if checkAndSetIsNetworking() { return }
        
        repo.checkEmailExist(email: email.lowercased()) { [weak self] result in
            self?.resetIsNetworking()
            switch result {
            case .success(let responce):
                if responce.code == 0 {
                    self?.email.accept(email)
                    self?.authType.accept(auth)
                    self?.credential.accept(credential)
                    self?.isEmailNotExist.accept(())
                } else {
                    Log.e(responce.code)
                    self?.isAlreadyExist.accept(())
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func registUser(name: String) {
        guard let email = email.value, let credential = credential.value, let autyType = authType.value else {
            Log.e("No data")
            isError.accept(MoyangError.unknown)
            return
        }
        if checkAndSetIsNetworking() { return }
        repo.registUser(email: email.lowercased(), pw: credential, name: name, authType: autyType) { [weak self] result in
            self?.resetIsNetworking()
            switch result {
            case .success(let response):
                Log.d(response)
                self?.isRegisterSuccess.accept(())
                UserData.shared.email = email
                UserData.shared.password = credential
                UserData.shared.userInfo = response
            case .failure(let error):
                Log.e(error)
                self?.isRegisterFailure.accept(())
            }
        }
    }
    
    func appLogin(email: String, credential: String) {
        guard let fcmToken = UserData.shared.fcmToken else {
            Log.e("No token")
            isLoginFailure.accept(())
            return
        }
        repo.appLogin(email: email.lowercased(), credential: credential, token: fcmToken) { [weak self] result in
            switch result {
            case .success(let user):
                Log.d(user)
                UserData.shared.email = email
                UserData.shared.password = credential
                UserData.shared.userInfo = user
                self?.isLoginSuccess.accept(())
            case .failure(let error):
                Log.e(error)
                self?.isLoginFailure.accept(())
            }
        }
    }
}

enum UserAuthType: String {
    case google = "GOOGLE"
    case apple = "APPLE"
}
