//
//  AlarmUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/29.
//

import Foundation
import RxSwift
import RxCocoa

class AlarmUseCase {
    let repo: AlarmRepo
    
    // MARK: - Lifecycle
    init(repo: AlarmRepo) {
        self.repo = repo
    }
}
