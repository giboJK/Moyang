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
}
