//
//  NoticeUseCase.swift
//  Moyang
//
//  Created by kibo on 2022/10/05.
//

import Foundation
import RxSwift
import RxCocoa

class NoticeUseCase {
    let repo: NoticeRepo
    
    let notices = BehaviorRelay<[Notice]>(value: [])
    var page: Int = 0
    var row: Int = 3
    
    var isNetworking = false
    // MARK: - Lifecycle
    init(repo: NoticeRepo) {
        self.repo = repo
    }
    
    func fetchLotices() {
        if isNetworking { return }
        isNetworking = true
        page = 0
        row = 5
        
        repo.fetchNotices(page: page, row: row) { [weak self] result in
            guard let self = self else { return }
            self.isNetworking = false
            switch result {
            case .success(let response):
                self.notices.accept(response.list)
            case .failure(let error):
                Log.e(error as Any)
            }
        }
    }
    
    func fetchMoreNotices() {
        if isNetworking { return }
        isNetworking = true
        page = row
        row += 5
        
        repo.fetchNotices(page: page, row: row) { [weak self] result in
            guard let self = self else { return }
            self.isNetworking = false
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
