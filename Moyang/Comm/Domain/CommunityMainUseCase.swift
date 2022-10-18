//
//  CommunityMainUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation
import RxSwift
import RxCocoa

class CommunityMainUseCase {
    typealias PrayList = [MyPray]
    let repo: CommunityMainRepo
    
    let groupInfo = BehaviorRelay<GroupInfo?>(value: nil)
    
    let amenSuccess = BehaviorRelay<Void>(value: ())
    let reactionSuccess = BehaviorRelay<Void>(value: ())
    
    let songName = BehaviorRelay<String?>(value: nil)
    let songURL = BehaviorRelay<URL?>(value: nil)
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let editingPraySuccess = BehaviorRelay<Void>(value: ())
    let editingPrayFailure = BehaviorRelay<Void>(value: ())
    
    let groupSummary = BehaviorRelay<GroupSummary?>(value: nil)
    let error = BehaviorRelay<MoyangError?>(value: nil)
    
    // MARK: - Lifecycle
    init(repo: CommunityMainRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    func fetchGroupSummary() {
        guard let myInfo = UserData.shared.userInfo else {
            Log.e("No user")
            return
        }
        
        repo.fetchGroupSummary(myInfo: myInfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.groupSummary.accept(data)
            case .failure(let error):
                Log.e(error)
                self.error.accept(.other(error))
            }
        }
    }
    func fetchGroupInfo() {
    }
    
    func addReply(memberAuth: String,
                  email: String,
                  prayID: String,
                  reply: String,
                  date: String,
                  reactions: [PrayReaction] = [],
                  order: Int) {
        if checkAndSetIsNetworking() { return }
    }
    private func checkAndSetIsNetworking() -> Bool {
        if isNetworking.value { Log.d("isNetworking..."); return true }
        isNetworking.accept(true)
        return false
    }
    
    private func resetIsNetworking() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.isNetworking.accept(false)
        }
    }
    
    func amen(time: Int, groupID: String) {
    }
}
