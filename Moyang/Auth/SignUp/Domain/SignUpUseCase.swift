//
//  SignUpUseCase.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpUseCase {
    // MARK: - Properties
    let repo: SignUpRepo
    
    // MARK: - Rx
    let isEmailNotExist = BehaviorRelay<Void>(value: ())
    let isError = BehaviorRelay<Error?>(value: nil)
    
    // MARK: - Lifecycle
    init(repo: SignUpRepo) {
        self.repo = repo
    }

    func checkEmailExist(email: String, credential: String, auth: String) {
        repo.checkEmailExist(email: email.lowercased()) { [weak self] result in
            switch result {
            case .success(let responce):
                if responce.code == 0 {
                    self?.isEmailNotExist.accept(())
                } else {
                    Log.e(responce.code)
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func registUser(email: String, pw: String, name: String, birth: String) {
        repo.registUser(email: email.lowercased(), pw: pw, name: name, birth: birth) { result in
            switch result {
            case .success(let response):
                Log.w(response)
            case .failure(let error):
                Log.e(error)
            }
        }
    }
}

enum UserAuthType: String {
    case google = "GOOGLE"
    case apple = "APPLE"
}
