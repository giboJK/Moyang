//
//  UseCase.swift
//  Moyang
//
//  Created by kibo on 2022/12/01.
//

import Foundation
import RxSwift
import RxCocoa


class UseCase {
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    func checkAndSetIsNetworking() -> Bool {
        if isNetworking.value {
            Log.d("isNetworking...")
            return true
        }
        isNetworking.accept(true)
        return false
    }
    
    func resetIsNetworking() {
        self.isNetworking.accept(false)
    }
}
