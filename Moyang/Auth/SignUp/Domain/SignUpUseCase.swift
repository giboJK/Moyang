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
    
    // MARK: - Lifecycle
    init(repo: SignUpRepo) {
        self.repo = repo
    }

    func registUser(id: String, pw: String, name: String) {
        repo.registUser(id: id, pw: pw, name: name) { result in
            switch result {
            case .success(let response):
                Log.w(response)
            case .failure(let error):
                Log.e(error)
            }
        }
    }
}
