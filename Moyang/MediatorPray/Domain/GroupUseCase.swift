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
    var memberPrayPage = 0
    var memberPrayRow = 20
    
    
    let myGroupMediatorInfos = BehaviorRelay<[GroupMediatorInfo]>(value: [])
    let groupEvents = BehaviorRelay<[GroupEvent]>(value: [])
    
    let searchedGroupList = BehaviorRelay<[GroupSearchedInfo]>(value: [])
    
    // MARK: - GroupDetail
    let groupDetail = BehaviorRelay<GroupDetail?>(value: nil)
    
    
    // MARK: - GroupMemberPrayList
    let memberPrayList = BehaviorRelay<[GroupMemberPray]>(value: [])
    
    
    // MARK: - GroupMemberPrayDetail
    let prayDetail = BehaviorRelay<PrayDetail?>(value: nil)
    
    
    // MARK: - Event
    let registerGroupSuccess = BehaviorRelay<Void>(value: ())
    let registerGroupFailure = BehaviorRelay<Void>(value: ())
    let exitGroupSuccess = BehaviorRelay<Void>(value: ())
    let exitGroupFailure = BehaviorRelay<Void>(value: ())
    
    /// Search
    let joinGroupReqSuccess = BehaviorRelay<Void>(value: ())
    let joinGroupReqFailure = BehaviorRelay<Void>(value: ())
    let acceptGroupReqSuccess = BehaviorRelay<Void>(value: ())
    let acceptGroupReqFailure = BehaviorRelay<Void>(value: ())
    
    /// DetailPray
    let addPraySuccess = BehaviorRelay<Void>(value: ())
    let addPrayFailure = BehaviorRelay<Void>(value: ())
    
    
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
        guard let myID = UserData.shared.userInfo?.id else { resetIsNetworking(); return }
        if checkAndSetIsNetworking() { return }
        repo.fetchGroupList(userID: myID, page: page, row: row) { [weak self] result in
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
        guard let myID = UserData.shared.userInfo?.id else { resetIsNetworking(); return }
        if checkAndSetIsNetworking() { return }
        repo.fetchMyGroupSummary(userID: myID) { [weak self] result in
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
    
    func joinGroup(groupID: String) {
        guard let myID = UserData.shared.userInfo?.id else { resetIsNetworking(); return }
        if checkAndSetIsNetworking() { return }
        repo.joinGroup(groupID: groupID, userID: myID) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.joinGroupReqSuccess.accept(())
                } else {
                    self.joinGroupReqFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.joinGroupReqFailure.accept(())
            }
        }
    }
    
    func acceptGroupJoinReq(reqID: String, isAccepted: Bool) {
        if checkAndSetIsNetworking() { return }
        
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
    
    func acceptGroupReq(reqID: String, isAccepted: Bool) {
        if checkAndSetIsNetworking() { return }
        repo.acceptGroup(reqID: reqID, isAccepted: isAccepted) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self.groupDetail.value

                    if isAccepted {
                        if let reqUser = cur?.reqs.first(where: { $0.reqID == reqID }) {
                            cur?.members.append(GroupMember(userID: reqUser.userID,
                                                            userName: reqUser.userName,
                                                            isLeader: false))
                        }
                    }
                    cur?.reqs.removeAll(where: { $0.reqID == reqID })
                    self.groupDetail.accept(cur)
                } else {
                    Log.e("")
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    // MARK: - GroupDetailMore
    func exitGroup(groupID: String) {
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.exitGroup(groupID: groupID, userID: myID) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self.myGroupMediatorInfos.value
                    cur.removeAll { $0.id == groupID }
                    self.myGroupMediatorInfos.accept(cur)
                    self.exitGroupSuccess.accept(())
                } else {
                    self.exitGroupFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self.exitGroupFailure.accept(())
            }
        }
    }
    
    // MARK: - GroupMemberPrayList
    func fetchInitialMemberPrayList(groupID: String, userID: String) {
        memberPrayPage = 0
        fetchPrayList(groupID: groupID, userID: userID)
    }
    
    func fetchMoreMemberPrayList(groupID: String, userID: String) {
        if isNetworking.value { return }
        memberPrayPage += 20
        fetchPrayList(groupID: groupID, userID: userID)
    }
    
    private func fetchPrayList(groupID: String, userID: String) {
        if checkAndSetIsNetworking() { return }
        repo.fetchGroupMemberPrayList(groupID: groupID, userID: userID, page: 0, row: 30) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self.memberPrayList.value
                    if cur.isEmpty {
                        self.memberPrayList.accept(response.data)
                    } else {
                        for item in response.data {
                            if !cur.contains(where: { $0.prayID == item.prayID }) {
                                cur.append(item)
                            }
                        }
                        self.memberPrayList.accept(cur)
                    }
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func clearMemberPray() {
        memberPrayList.accept([])
    }
    
    func fetchPrayDetail(prayID: String) {
        if checkAndSetIsNetworking() { return }
        repo.fetchPrayDetail(prayID: prayID) { [weak self] result in
            self?.resetIsNetworking()
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self?.prayDetail.accept(response.data)
                } else {
                    Log.e("")
                }
            case .failure(let error):
                Log.e(error)
            }
        }
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
