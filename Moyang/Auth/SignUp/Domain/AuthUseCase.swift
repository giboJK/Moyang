//
//  AuthUseCase.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation
import RxSwift
import RxCocoa

class AuthUseCase {
    // MARK: - Properties
    let repo: AuthRepo
    
    // MARK: - Rx
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let isAlreadyExist = BehaviorRelay<Void>(value: ())
    let isEmailNotExist = BehaviorRelay<Void>(value: ())
    let isError = BehaviorRelay<Error?>(value: nil)
    
    let email = BehaviorRelay<String?>(value: nil)
    let credential = BehaviorRelay<String?>(value: nil)
    let authType = BehaviorRelay<String?>(value: nil)
    
    let isRegisterSuccess = BehaviorRelay<Void>(value: ())
    let isRegisterFailure = BehaviorRelay<Void>(value: ())
    
    let isLoginSuccess = BehaviorRelay<Void>(value: ())
    let isLoginFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - Lifecycle
    init(repo: AuthRepo) {
        self.repo = repo
    }

    func checkEmailExist(email: String, credential: String, auth: String) {
        if checkAndSetIsNetworking() {
            return
        }
        
        repo.checkEmailExist(email: email.lowercased()) { [weak self] result in
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
            self?.isNetworking.accept(false)
        }
    }
    
    func registUser(name: String, birth: String) {
        guard let email = email.value, let credential = credential.value, let autyType = authType.value else {
            Log.e("No data")
            isError.accept(MoyangError.unknown)
            return
        }
        if checkAndSetIsNetworking() {
            return
        }
        repo.registUser(email: email.lowercased(), pw: credential, name: name, birth: birth, authType: autyType) { [weak self] result in
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
            self?.isNetworking.accept(false)
        }
    }
    
    func appLogin(email: String, credential: String) {
        if checkAndSetIsNetworking() {
            return
        }
        repo.appLogin(email: email.lowercased(), credential: credential) { [weak self] result in
            switch result {
            case .success(let user):
                Log.d(user)
                UserData.shared.email = email
                UserData.shared.password = credential
                UserData.shared.userInfo = user
                UserData.shared.groupID = user.groupList.first?.id
                UserData.shared.groupInfo = user.groupList.first
                self?.isLoginSuccess.accept(())
            case .failure(let error):
                Log.e(error)
                self?.isLoginFailure.accept(())
            }
            self?.isNetworking.accept(false)
        }
    }
    
    private func checkAndSetIsNetworking() -> Bool {
        if isNetworking.value {
            Log.d("isNetworking...")
            return true
        }
        isNetworking.accept(true)
        return false
    }
}

enum UserAuthType: String {
    case google = "GOOGLE"
    case apple = "APPLE"
}
