//
//  FirestoreLoginServiceImpl.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import Combine
import FirebaseAuth

class FirestoreLoginServiceImpl: LoginService {
    func signup(id: String, pw: String) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            Auth.auth().createUser(withEmail: id, password: pw) { authResult, error in
                if let error = error {
                    promise(.failure(MoyangError.other(error)))
                } else {
                    guard let user = authResult?.user else { return }
                    Log.d(user)
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func login(id: String, pw: String) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            Auth.auth().signIn(withEmail: id, password: pw) { (result, error) in
                if let error = error {
                    Log.e(error)
                    promise(.failure(MoyangError.other(error)))
                } else {
                    guard let user = result?.user else { return }
                    Log.d(user)
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
}
