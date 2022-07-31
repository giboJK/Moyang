//
//  MemberRepoImpl.swift
//  Moyang
//
//  Created by kibo on 2022/02/22.
//

import Foundation
import Combine

class MemberRepoImpl: MemberRepo {
    
    private let service: FirestoreService
        
        
    init(service: FirestoreService) {
        self.service = service
    }
    
    deinit {
        Log.d(self)
    }
}
