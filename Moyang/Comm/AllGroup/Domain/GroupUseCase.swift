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
    
    let groupInfoList = BehaviorRelay<[GroupInfo]>(value: [])
    let groupEvents = BehaviorRelay<[GroupEvent]>(value: [])
    
    // MARK: - Lifecycle
    init(repo: GroupRepo) {
        self.repo = repo
    }
    
    // MARK: - Function
    
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
}
