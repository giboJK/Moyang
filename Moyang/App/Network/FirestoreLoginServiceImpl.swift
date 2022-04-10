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
    
    func signup(id: String, pw: String, type: AuthType) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            Auth.auth().createUser(withEmail: id, password: pw) { _, error in
                if let error = error {
                    promise(.failure(MoyangError.other(error)))
                } else {
                    Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                        if let error = error {
                            promise(.failure(MoyangError.other(error)))
                        } else {
                            promise(.success(true))
                        }
                    })
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func login(id: String, pw: String, type: AuthType) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            Auth.auth().signIn(withEmail: id, password: pw) { (result, error) in
                if let error = error {
                    let errorCode = (error as NSError).code
                    if errorCode == 17009 {
                        promise(.failure(MoyangError.passwordInvalid))
                    } else if errorCode == 17011 {
                        promise(.failure(MoyangError.noUser))
                    } else {
                        promise(.failure(MoyangError.other(error)))
                    }
                } else {
                    if let result = result {
                        if result.user.isEmailVerified {
                            promise(.success(true))
                        } else {
                            promise(.failure(MoyangError.notVerified))
                            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                                if let error = error {
                                    promise(.failure(MoyangError.other(error)))
                                }
                            })
                        }
                    } else {
                        promise(.failure(MoyangError.noUser))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func pastorLogin(id: String, pw: String, type: AuthType) -> AnyPublisher<Bool, MoyangError> {
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
    
    func fetchPastorList(type: AuthType) -> AnyPublisher<PastorList, MoyangError> {
        let ref = service.store
            .collection("PASTOR")
            .document("YD")
            .collection("AUTH")
            .document(type.rawValue)
        
        return service.fetchObject(ref: ref, type: PastorList.self)
    }
    
    func fetchUserData(id: String, type: AuthType) -> AnyPublisher<MemberDetail, MoyangError> {
        let ref = service.store
            .collection("USER")
            .document("AUTH")
            .collection(type.rawValue)
            .document(id.lowercased())
        
        return service.fetchObject(ref: ref, type: MemberDetail.self)
    }
    
    func setUserData(memberDetail: MemberDetail) -> AnyPublisher<Bool, MoyangError> {
        let ref = service.store
            .collection("USER")
            .document("AUTH")
            .collection(memberDetail.authType)
            .document(memberDetail.email)
        
        return service.addDocument(memberDetail, ref: ref)
    }
}
