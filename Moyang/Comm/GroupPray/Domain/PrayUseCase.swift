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
    func addPray(pray: String, tags: [String], isSecret: Bool) {
        guard let groupID = UserData.shared.groupInfo?.id else { Log.e("No group ID"); return }
        guard let userID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        repo.addPray(userID: userID,
                     groupID: groupID,
                     content: pray,
                     tags: tags,
                     isSecret: isSecret) { [weak self] result in
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self?.addingNewPraySuccess.accept(())
                } else {
                    self?.addingNewPrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self?.addingNewPrayFailure.accept(())
            }
        }
    }
    
    func updatePray(prayID: String, pray: String, tags: [String], isSecret: Bool) {
    }
    
    func fetchPrayList(page: Int, row: Int = 5) {
        guard let groupID = UserData.shared.groupInfo?.id else { Log.e("No group ID"); return }
        guard let userID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        repo.fetchPrayList(groupID: groupID, userID: userID, page: page, row: row) { [weak self] result in
            switch result {
            case .success(let list):
                Log.d(list)
            case .failure(let error):
                Log.e(error)
            }
        }
    }
}
