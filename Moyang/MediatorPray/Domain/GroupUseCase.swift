//
//  GroupUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import Foundation
import RxSwift
import RxCocoa

class GroupUseCase: UseCase {
    // MARK: - Properties
    let repo: GroupRepo
    let prayRepo: MyPrayRepo
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
    
    /// Change & Answer
    let addChangeSuccess = BehaviorRelay<Void>(value: ())
    let addChangeFailure = BehaviorRelay<Void>(value: ())
    let addAnswerSuccess = BehaviorRelay<Void>(value: ())
    let addAnswerFailure = BehaviorRelay<Void>(value: ())
    
    /// Search
    let joinGroupReqSuccess = BehaviorRelay<Void>(value: ())
    let joinGroupReqFailure = BehaviorRelay<Void>(value: ())
    let acceptGroupReqSuccess = BehaviorRelay<Void>(value: ())
    let acceptGroupReqFailure = BehaviorRelay<Void>(value: ())
    
    /// DetailPray
    let addPraySuccess = BehaviorRelay<Void>(value: ())
    let addPrayFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - Lifecycle
    init(repo: GroupRepo, prayRepo: MyPrayRepo) {
        self.repo = repo
        self.prayRepo = prayRepo
        
        super.init()
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
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No ID"); return }
        if checkAndSetIsNetworking() { return }
        repo.fetchGroupDetail(groupID: groupID, userID: myID) { [weak self] result in
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
    func fetechInitialMyPrayList(groupID: String, userID: String) {
        memberPrayPage = 0
        fetchMyPrayList(groupID: groupID, userID: userID)
    }
    
    func fetchMoreMyPrayList(groupID: String, userID: String) {
        if isNetworking.value { return }
        memberPrayPage += 20
        fetchMyPrayList(groupID: groupID, userID: userID)
    }
    
    private func fetchMyPrayList(groupID: String, userID: String) {
        if checkAndSetIsNetworking() { return }
        repo.fetchMyPrayList(userID: userID, page: memberPrayPage, row: 20) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                var cur = self.memberPrayList.value
                if cur.isEmpty {
                    self.memberPrayList.accept(response)
                } else {
                    for item in response {
                        if !cur.contains(where: { $0.prayID == item.prayID }) {
                            cur.append(item)
                        }
                    }
                    self.memberPrayList.accept(cur)
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    ///
    func fetchInitialMemberPrayList(groupID: String, userID: String) {
        memberPrayPage = 0
        fetchMemberPrayList(groupID: groupID, userID: userID)
    }
    
    func fetchMoreMemberPrayList(groupID: String, userID: String) {
        if isNetworking.value { return }
        memberPrayPage += 20
        fetchMemberPrayList(groupID: groupID, userID: userID)
    }
    
    private func fetchMemberPrayList(groupID: String, userID: String) {
        if checkAndSetIsNetworking() { return }
        repo.fetchGroupMemberPrayList(groupID: groupID, userID: userID,
                                      page: memberPrayPage,
                                      row: 20) { [weak self] result in
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
    
    func addReply(prayID: String, myID: String, content: String) {
        if checkAndSetIsNetworking() { return }
        repo.addReply(prayID: prayID, myID: myID, content: content) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var cur = self.prayDetail.value
                    cur?.replys.append(response.data)
                    self.prayDetail.accept(cur)
                    self.addPraySuccess.accept(())
                } else {
                    self.addPrayFailure.accept(())
                    Log.e("")
                }
            case .failure(let error):
                Log.e(error)
                self.addPrayFailure.accept(())
            }
        }
    }
    
    func addAnswer(answer: String) {
        guard let prayID = prayDetail.value?.prayID else { Log.e("No pray ID"); return }
        addAnswer(prayID: prayID, answer: answer)
    }
    
    func addChange(change: String) {
        guard let prayID = prayDetail.value?.prayID else { Log.e("No pray ID"); return }
        addChange(prayID: prayID, change: change)
    }
    
    private func addAnswer(prayID: String, answer: String) {
        if checkAndSetIsNetworking() { return }
        prayRepo.addAnswer(prayID: prayID, answer: answer) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.addAnswerSuccess.accept(())
                    var cur = self.prayDetail.value!
                    cur.answers.append(response.data)
                    self.prayDetail.accept(cur)
                } else {
                    self.addAnswerFailure.accept(())
                    Log.e(response.errorMessage ?? "")
                }
            case .failure(let error):
                Log.e(error)
                self.addAnswerFailure.accept(())
            }
        }
    }
    
    // Select has new Item
    func checkNewPray(infoID: String, prayID: String) {
        prayRepo.updatePrayReadInfo(infoID: infoID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    var groupDetail = self.groupDetail.value
                    if var prayIndex = groupDetail?.prays.firstIndex(where: { $0.prayID == prayID }) {
                        groupDetail?.prays[prayIndex].hasNew = false
                        self.groupDetail.accept(groupDetail)
                    }
                } else {
                    Log.e("")
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    
    private func addChange(prayID: String, change: String) {
        if checkAndSetIsNetworking() { return }
        prayRepo.addChange(prayID: prayID, change: change) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self.addChangeSuccess.accept(())
                    var cur = self.prayDetail.value!
                    cur.changes.append(response.data)
                    self.prayDetail.accept(cur)
                } else {
                    self.addChangeFailure.accept(())
                    Log.e(response.errorMessage ?? "")
                }
            case .failure(let error):
                Log.e(error)
                self.addChangeFailure.accept(())
            }
        }
    }
    
    func clearPrayDetail() {
        prayDetail.accept(nil)
    }
}
