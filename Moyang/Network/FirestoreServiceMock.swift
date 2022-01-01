//
//  FireStoreServiceMock.swift
//  Moyang
//
//  Created by kibo on 2022/01/01.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FireStoreServiceMock: FirestoreService {
    var store = Firestore.firestore()

    func addDocument<T>(_ object: T, ref: CollectionReference) -> AnyPublisher<Bool, MoyangError> where T : Decodable, T : Encodable {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func addDocument<T>(_ object: T, ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> where T : Decodable, T : Encodable {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func addListener<T>(ref: CollectionReference, type: T.Type) -> PassthroughSubject<T, MoyangError> where T : Decodable, T : Encodable {
        let subject = PassthroughSubject<T, MoyangError>()
        Log.w(String(describing: type))
        return subject
    }
    
    func addListener<T>(ref: CollectionReference, type: T.Type) -> PassthroughSubject<[T], MoyangError> where T : Decodable, T : Encodable {
        let subject = PassthroughSubject<[T], MoyangError>()
        Log.w(String(describing: type))
        return subject
    }
}
