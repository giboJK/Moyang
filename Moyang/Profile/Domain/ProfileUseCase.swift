//
//  ProfileUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/30.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileUseCase: UseCase {
    // MARK: - Properties
    let repo: AuthRepo
    
    let userInfo = BehaviorRelay<UserInfo?>(value: nil)
    
    // MARK: - Event
    let deletionSuccess = BehaviorRelay<Void>(value: ())
    let deletionFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - Lifecycle
    init(repo: AuthRepo) {
        self.repo = repo
        
        super.init()
        
        initData()
    }
    
    private func initData() {
        guard let userInfo = UserData.shared.userInfo else { Log.e("No User?"); return }
        self.userInfo.accept(userInfo)
    }
    
    func deleteUser() {
        guard let myID = UserData.shared.userInfo?.id else { return }
        if checkAndSetIsNetworking() { return }
        repo.deleteUser(myID: myID) { [weak self] result in
            self?.resetIsNetworking()
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self?.deletionSuccess.accept(())
                } else {
                    self?.deletionFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self?.deletionFailure.accept(())
            }
        }
    }
}
