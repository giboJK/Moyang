//
//  PrayUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

class PrayUseCase {
    let repo: PrayRepo
    
    let addingNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addingNewPrayFailure = BehaviorRelay<Void>(value: ())
    let editingPraySuccess = BehaviorRelay<Void>(value: ())
    let editingPrayFailure = BehaviorRelay<Void>(value: ())
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Lifecycle
    init(repo: PrayRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    func editPray(prayID: String, pray: String, tags: [String], isSecret: Bool, isRequestPray: Bool) {
    }
}
