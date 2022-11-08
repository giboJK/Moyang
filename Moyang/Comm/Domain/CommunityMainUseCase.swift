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
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Lifecycle
    init(repo: CommunityMainRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    func fetchGroupSummary() {
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
        self.isNetworking.accept(false)
    }
    
    func amen(time: Int, groupID: String) {
    }
}
