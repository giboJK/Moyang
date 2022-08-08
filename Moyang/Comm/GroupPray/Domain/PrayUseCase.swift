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
    
    let memberPrayList = BehaviorRelay<[String: [GroupIndividualPray]]>(value: [:])
    
    let addNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addNewPrayFailure = BehaviorRelay<Void>(value: ())
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let userIDNameDict = BehaviorRelay<[String: String]>(value: [:])
    private var userPrayFetchDate = [String: Set<String>]() // 유저별로 해당 날짜의 기도를 불러온 적이 있는지 저장하는 모델
    
    // MARK: - Lifecycle
    init(repo: PrayRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    // 아래 함수가 먼저 실행이 되어야 함
    func fetchPrayAll(order: String, row: Int = 2) {
        guard let groupID = UserData.shared.groupInfo?.id else { Log.e("No group ID"); return }
        guard let userID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() {
            return
        }
        repo.fetchPrayAll(groupID: groupID, userID: userID, order: order, page: 0, row: row) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                // 만약에 기도를 하나도 등록하지 않은 유저가 있을 경우 생성되지 않음
                var userIDNameDict = [String: String]()
                response.forEach { item in
                    userIDNameDict.updateValue(item.userName, forKey: item.userID)
                    self.userPrayFetchDate.updateValue(Set<String>(), forKey: item.userID) // 최초에는 저장 공간을 만들어두기만 한다. 하루에 여러 기도를 저장할 수 있으므로.
                }
                self.userIDNameDict.accept(userIDNameDict)
                var prayDict = [String: [GroupIndividualPray]]()
                userIDNameDict.keys.forEach { key in
                    prayDict.updateValue([], forKey: key)
                }
                
                response.forEach { item in
                    if var list = prayDict[item.userID] {
                        if !item.prayID.isEmpty {
                            list.append(item)
                            prayDict.updateValue(list, forKey: item.userID)
                        }
                    }
                }
                self.memberPrayList.accept(prayDict)
            case .failure(let error):
                Log.e(error)
            }
            self.isNetworking.accept(false)
        }
    }
    func addPray(pray: String, tags: [String], isSecret: Bool) {
        guard let groupID = UserData.shared.groupInfo?.id else { Log.e("No group ID"); return }
        guard let userID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() {
            return
        }
        repo.addPray(userID: userID,
                     groupID: groupID,
                     content: pray,
                     tags: tags,
                     isSecret: isSecret) { [weak self] result in
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self?.addNewPraySuccess.accept(())
                } else {
                    self?.addNewPrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self?.addNewPrayFailure.accept(())
            }
            self?.isNetworking.accept(false)
        }
    }
    
    func updatePray(prayID: String, pray: String, tags: [String], isSecret: Bool) {
        if checkAndSetIsNetworking() {
            return
        }
        guard let myID = UserData.shared.userInfo?.id else {
            updatePrayFailure.accept(()); return
        }
        repo.updatePray(prayID: prayID,
                        pray: pray,
                        tags: tags,
                        isSecret: isSecret) { [weak self] result in
            switch result {
            case .success(let response):
                if response.code == 0 {
                    self?.updatePraySuccess.accept(())
                    self?.updatePray(userID: myID, prayID: prayID, pray: pray, tags: tags, isSecret: isSecret)
                } else {
                    self?.updatePrayFailure.accept(())
                }
            case .failure(let error):
                Log.e(error)
                self?.addNewPrayFailure.accept(())
            }
            self?.isNetworking.accept(false)
        }
    }
    
    func fetchPrayList(userID: String, order: String, page: Int, row: Int = 3) {
        guard let groupID = UserData.shared.groupInfo?.id else { Log.e("No group ID"); return }
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user ID"); return }
        if checkAndSetIsNetworking() {
            return
        }
        let isMe = userID == myID
        repo.fetchPrayList(groupID: groupID, userID: userID, isMe: isMe, order: order, page: page, row: row) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                Log.d(list)
            case .failure(let error):
                Log.e(error)
            }
            self.isNetworking.accept(false)
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
    
    private func updatePray(userID: String, prayID: String, pray: String, tags: [String], isSecret: Bool) {
        if var list = memberPrayList.value[userID] {
            if let index = list.firstIndex(where: { $0.prayID == prayID }) {
                list[index].pray = pray
                list[index].tags = tags
                list[index].isSecret = isSecret
                var dict = memberPrayList.value
                dict.updateValue(list, forKey: userID)
                memberPrayList.accept(dict)
            }
        }
    }
}
