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
    
    func fetchMemberList() -> PassthroughSubject<[MemberDetail], MoyangError> {
        let emailRef = service.store
            .collection("USER")
            .document("AUTH")
            .collection("EMAIL")
        
        return service.addListener(ref: emailRef, type: MemberDetail.self)
    }
}
