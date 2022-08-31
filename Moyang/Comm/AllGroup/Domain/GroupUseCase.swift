//
//  GroupUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import Foundation
import RxSwift
import RxCocoa

class GroupUseCase {
    let repo: GroupRepo
    
    let groupInfoList = BehaviorRelay<[GroupInfo]>(value: [])
    
    // MARK: - Lifecycle
    init(repo: GroupRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    func fetchGroupList() {
    }
    
    func fetchEvents() {
        
    }
}
