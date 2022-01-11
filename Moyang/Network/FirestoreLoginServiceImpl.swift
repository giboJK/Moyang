//
//  FirestoreLoginServiceImpl.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import Combine
import Firebase

class FirestoreLoginServiceImpl: LoginService {
    func signup(id: String, pw: String) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            promise(.failure(MoyangError.writingFailed))
        }.eraseToAnyPublisher()
    }
    
    func login(id: String, pw: String) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            promise(.failure(MoyangError.writingFailed))
        }.eraseToAnyPublisher()
    }
}
