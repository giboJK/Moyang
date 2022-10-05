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
    
    
    // MARK: - Lifecycle
    init(repo: NoticeRepo) {
        self.repo = repo
    }
}
