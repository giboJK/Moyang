//
//  AllGroupUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import Foundation
import RxSwift
import RxCocoa

class AllGroupUseCase {
    let repo: AllGroupRepo
    
    let groupInfoList = BehaviorRelay<[GroupInfo]>(value: [])
    
    // MARK: - Lifecycle
    init(repo: AllGroupRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    func fetchGroupList() {
    }
}
