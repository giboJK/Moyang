//
//  FireStoreService.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/15.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FireStoreService {
    
    deinit { Log.i(self) }
    
    let store = Firestore.firestore()
    
    func addDocument<T: Codable>(_ object: T,
                                 ref: CollectionReference) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            do {
                _ = try ref.addDocument(from: object)
                promise(.success(true))
            } catch {
                promise(.failure(MoyangError.writingFailed))
            }
        }.eraseToAnyPublisher()
    }
    
    func addDocument<T: Codable>(_ object: T,
                                 ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> {
        return Future<Bool, MoyangError> { promise in
            do {
                _ = try ref.setData(from: object)
                promise(.success(true))
            } catch {
                promise(.failure(MoyangError.writingFailed))
            }
        }.eraseToAnyPublisher()
    }
        
    func addListener<T: Codable>(ref: CollectionReference,
                                 type: T.Type) -> PassthroughSubject<T, MoyangError> {
        let listener = PassthroughSubject<T, MoyangError>()
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                listener.send(completion: .failure(.other(error)))
            }
            if let query = querySnapshot {
                let objectList = query.documents.compactMap { document in
                    try? document.data(as: T.self)
                }
                if let object = objectList.first {
                    listener.send(object)
                } else {
                    listener.send(completion: .failure(.decodingFailed))
                }
            } else {
                listener.send(completion: .failure(.emptyData))
            }
        }
        
        return listener
    }
    
    func addListener<T: Codable>(ref: CollectionReference,
                                 type: T.Type) -> PassthroughSubject<[T], MoyangError> {
        let listener = PassthroughSubject<[T], MoyangError>()
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                listener.send(completion: .failure(.other(error)))
            }
            if let query = querySnapshot {
                let objectList = query.documents.compactMap { document in
                    try? document.data(as: T.self)
                }
                listener.send(objectList)
            } else {
                listener.send(completion: .failure(.decodingFailed))
            }
        }
        
        return listener
    }
}
