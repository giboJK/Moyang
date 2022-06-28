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
        guard let myInfo = UserData.shared.myInfo else { Log.e(""); return }
        repo.editPray(myInfo: myInfo, prayID: prayID, pray: pray, tags: tags, isSecret: isSecret, isRequestPray: isRequestPray) { [weak self] result in
            switch result {
            case .success(let isSuccess):
                if isSuccess {
                    self?.editingPraySuccess.accept(())
                } else {
                    self?.editingPrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self?.editingPrayFailure.accept(())
            }
        }
    }
}
