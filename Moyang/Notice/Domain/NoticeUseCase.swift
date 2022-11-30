//
//  NoticeUseCase.swift
//  Moyang
//
//  Created by kibo on 2022/10/05.
//

import Foundation
import RxSwift
import RxCocoa

class NoticeUseCase: UseCase {
    let repo: NoticeRepo
    
    let notices = BehaviorRelay<[Notice]>(value: [])
    var page: Int = 0
    var row: Int = 5
    
    
    // MARK: - Lifecycle
    init(repo: NoticeRepo) {
        self.repo = repo
    }
    
    func fetchLotices() {
        if checkAndSetIsNetworking() { return }
        page = 0
        row = 5
        
        repo.fetchNotices(page: page, row: row) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.notices.accept(response.list)
            case .failure(let error):
                Log.e(error as Any)
            }
        }
    }
    
    func fetchMoreNotices() {
        if checkAndSetIsNetworking() { return }
        page = row
        row += 5
        
        repo.fetchNotices(page: page, row: row) { [weak self] result in
            self?.resetIsNetworking()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                var list = self.notices.value
                list.append(contentsOf: response.list)
                self.notices.accept(list)
            case .failure(let error):
                Log.e(error as Any)
            }
        }
    }
}
