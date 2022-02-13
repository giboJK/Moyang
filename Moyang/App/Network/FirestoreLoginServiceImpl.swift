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
    
    func signup(id: String, pw: String, type: LoginType) -> AnyPublisher<Bool, MoyangError> {
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
    
    func login(id: String, pw: String, type: LoginType) -> AnyPublisher<Bool, MoyangError> {
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
    
    func pastorLogin(id: String, pw: String, type: LoginType) -> AnyPublisher<Bool, MoyangError> {
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
    
    func fetchPastorList(type: LoginType) -> AnyPublisher<PastorList, MoyangError> {
        let ref = service.store
            .collection("PASTOR")
            .document("YD")
            .collection("AUTH")
            .document(type.rawValue)
        
        return service.fetchObject(ref: ref, type: PastorList.self)
    }
    
    func fetchUserData(id: String, type: LoginType) -> AnyPublisher<MemberDetail, MoyangError> {
        let ref = service.store
            .collection("USER")
            .document("AUTH")
            .collection(type.rawValue)
            .document(id)
        
        return service.fetchObject(ref: ref, type: MemberDetail.self)
    }
    
    func setUserData(memberDetail: MemberDetail) -> AnyPublisher<Bool, MoyangError> {
        let ref = service.store
            .collection("USER")
            .document("AUTH")
            .collection(memberDetail.authType)
            .document(memberDetail.id)
        
        return service.addDocument(memberDetail, ref: ref)
    }
}
