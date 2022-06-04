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
    let repo: CommunityMainRepo
    
    let groupInfo = BehaviorRelay<GroupInfo?>(value: nil)
    let cardMemberPrayList = BehaviorRelay<[(pray: GroupIndividualPray, member: Member)]>(value: [])
    let addingNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addingNewPrayFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - Lifecycle
    init(repo: CommunityMainRepo) {
        self.repo = repo
    }
    
    func fetchGroupInfo() {
        guard let myInfo = UserData.shared.myInfo else {
            return
        }
        guard let groupID = myInfo.groupList.first else {
            return 
        }
        
        repo.fetchGroupInfo(community: myInfo.community.uppercased(), groupID: groupID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groupInfo):
                self.groupInfo.accept(groupInfo)
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func fetchMemberIndividualPray(member: Member, groupID: String, limit: Int = 1) {
        repo.fetchMemberIndividualPray(member: member, groupID: groupID, limit: limit) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groupIndividualPrayList):
                if let obj = groupIndividualPrayList.first {
                    var current = self.cardMemberPrayList.value
                    current.append((obj, member))
                    self.cardMemberPrayList.accept(current)
                }
            case .failure(let error):
                Log.e(error)
            }
        }
    }
    
    func addIndividualPray(id: String,
                           groupID: String,
                           date: String,
                           pray: String,
                           tags: [String]) {
        guard let myInfo = UserData.shared.myInfo else {
            addingNewPrayFailure.accept(())
            return
        }
        let data = GroupIndividualPray(id: id, groupID: groupID, date: date, pray: pray, tags: tags)
        repo.addIndividualPray(data: data, myInfo: myInfo) { [weak self] result in
            switch result {
            case .success:
                self?.addingNewPraySuccess.accept(())
                self?.updateCardMemberPrayListWithNewPray(pray: data, myInfo: myInfo)
            case .failure(let error):
                Log.e(error)
                self?.addingNewPrayFailure.accept(())
            }
        }
    }
    
    private func updateCardMemberPrayListWithNewPray(pray: GroupIndividualPray, myInfo: MemberDetail) {
        var current = cardMemberPrayList.value
        if let firstIndex = current.firstIndex(where: { $0.member.id == myInfo.id }) {
            current[firstIndex].pray = pray
            cardMemberPrayList.accept(current)
        }
    }
}
