//
//  FirestoreLoginServiceImpl.swift
//  Moyang
//
//  Created by kibo on 2022/01/11.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreLoginServiceImpl: LoginService {
    private let service: FirestoreService
    private let collectionName = "USER"
    
    init(service: FirestoreService) {
        self.service = service
    }
    
    func signup(id: String, pw: String) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            Auth.auth().createUser(withEmail: id, password: pw) { _, error in
                if let error = error {
                    promise(.failure(MoyangError.other(error)))
                } else {
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func login(id: String, pw: String) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            Auth.auth().signIn(withEmail: id, password: pw) { (result, error) in
                if let error = error {
                    promise(.failure(MoyangError.other(error)))
                } else {
                    guard result?.user != nil else { return }
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func pastorLogin(id: String, pw: String) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            Auth.auth().signIn(withEmail: id, password: pw) { (result, error) in
                if let error = error {
                    promise(.failure(MoyangError.other(error)))
                } else {
                    guard result?.user != nil else { return }
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchPastorList() -> AnyPublisher<PastorList, MoyangError> {
        let ref = service.store
            .collection("PASTOR")
            .document("YD")
        
        return service.fetchObject(ref: ref, type: PastorList.self)
    }
    
    func fetchUserData() -> AnyPublisher<MemberDetail, MoyangError> {
        guard let userID = UserData.shared.userID?.lowercased() else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        let ref = service.store
            .collection(self.collectionName)
            .document(userID)
        
        return service.fetchObject(ref: ref, type: MemberDetail.self)
    }
}
