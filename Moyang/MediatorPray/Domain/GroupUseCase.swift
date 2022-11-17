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
    
    let myGroupMediatorInfos = BehaviorRelay<[GroupMediatorInfo]>(value: [])
    let groupEvents = BehaviorRelay<[GroupEvent]>(value: [])
    
    
    // MARK: - Event
    let registerGroupSuccess = BehaviorRelay<Void>(value: ())
    let registerGroupFailure = BehaviorRelay<Void>(value: ())
    
    
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    
    // MARK: - Lifecycle
    init(repo: GroupRepo) {
        self.repo = repo
    }
    
    
    // MARK: - Functions
    
    func registerGroup(name: String, desc: String) {
        guard let userID = UserData.shared.userInfo?.id else { resetIsNetworking(); return }
        if checkAndSetIsNetworking() { return }
        repo.registerGroup(userID: userID, name: name, desc: desc) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.registerGroupSuccess.accept(())
                } else {
                    self.registerGroupFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.registerGroupFailure.accept(())
            }
        }
    }
    
    func fetchMyGroupSummary() {
        guard let userID = UserData.shared.userInfo?.id else { resetIsNetworking(); return }
        if checkAndSetIsNetworking() { return }
        repo.fetchMyGroupSummary(userID: userID) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.myGroupMediatorInfos.accept(response.data)
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    
    func fetchEvents(groupID: String, date: String) {
        repo.fetchGroupEvent(groupID: groupID, isWeek: true, date: date) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self.groupEvents.value
                    cur.append(contentsOf: response.data)
                    self.groupEvents.accept(cur)
                } else {
                    Log.e("")
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func fetchGroupDetail(groupID: String) {
        
    }
    
    private func checkAndSetIsNetworking() -> Bool {
        if isNetworking.value {
            Log.d("isNetworking...")
            return true
        }
        isNetworking.accept(true)
        return false
    }
    
    private func resetIsNetworking() {
        self.isNetworking.accept(false)
    }
}
