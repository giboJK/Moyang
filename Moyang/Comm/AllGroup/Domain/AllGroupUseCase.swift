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
        guard let myInfo = UserData.shared.myInfo else { return }
        repo.fetchGroupList(myInfo: myInfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.groupInfoList.accept(list)
            case .failure(let error):
                Log.e(error)
            }
        }
    }
}
