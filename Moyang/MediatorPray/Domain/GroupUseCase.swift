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
    // MARK: - Properties
    let repo: GroupRepo
    var page = 0
    var row = 10
    
    
    let myGroupMediatorInfos = BehaviorRelay<[GroupMediatorInfo]>(value: [])
    let groupEvents = BehaviorRelay<[GroupEvent]>(value: [])
    
    let searchedGroupList = BehaviorRelay<[GroupSearchedInfo]>(value: [])
    
    // MARK: - GroupDetail
    let groupDetail = BehaviorRelay<GroupDetail?>(value: nil)
    
    
    
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
    
    func fetchInitialGroupList() {
        page = 0
        fetchGroupList()
    }
    
    func fetchMoreGroupList() {
        page = searchedGroupList.value.count
        fetchGroupList()
    }
    
    
    private func fetchGroupList() {
        if checkAndSetIsNetworking() { return }
        repo.fetchGroupList(page: page, row: row) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self.searchedGroupList.value
                    if cur.isEmpty {
                        self.searchedGroupList.accept(response.data)
                    } else {
                        for item in response.data {
                            if !cur.contains(where: { $0.id == item.id }) {
                                cur.append(item)
                            }
                        }
                        self.searchedGroupList.accept(cur)
                    }
                }
            case .failure(let error):
                Log.e(error)
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
        if checkAndSetIsNetworking() { return }
        repo.fetchGroupDetail(groupID: groupID) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.groupDetail.accept(response.data)
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    // MARK: - GroupDetailMore
    func exitGroup(groupID: String, userID: String) {
    }
    
    // MARK: - GroupMemberPrayList
    func fetchPrayList(groupID: String, userID: String) {
        
    }
    
    func fetchPrayDetail(prayID: String) {
        
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
