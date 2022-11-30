//
//  ProfileUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/30.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileUseCase {
    // MARK: - Properties
    let repo: AuthRepo
    
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Lifecycle
    init(repo: AuthRepo) {
        self.repo = repo
    }
    
    
    
}
