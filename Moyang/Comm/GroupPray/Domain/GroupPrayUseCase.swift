//
//  GroupPrayUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

class GroupPrayUseCase {
    let repo: GroupPrayRepo
    
    let editingPraySuccess = BehaviorRelay<Void>(value: ())
    let editingPrayFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - Lifecycle
    init(repo: GroupPrayRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    func editPray(prayID: String, pray: String, tags: [String], isSecret: Bool, isRequestPray: Bool) {
    }
}
