//
//  FireStoreServiceImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/15.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FirestoreServiceImpl: FirestoreService {
    
    deinit { Log.i(self) }
    
    var store = Firestore.firestore()
    
    func addDocument<T: Codable>(_ object: T,
                                 ref: CollectionReference) -> AnyPublisher<Bool, MoyangError> {
        Log.d(ref.path)
        return Future<Bool, MoyangError> { promise in
            do {
                _ = try ref.addDocument(from: object)
                promise(.success(true))
            } catch {
                Log.e(error)
                promise(.failure(MoyangError.writingFailed))
            }
        }.eraseToAnyPublisher()
    }
    
    func addDocument<T: Codable>(_ object: T,
                                 ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> {
        Log.d(ref.path)
        return Future<Bool, MoyangError> { promise in
            do {
                _ = try ref.setData(from: object)
                promise(.success(true))
            } catch {
                promise(.failure(MoyangError.writingFailed))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateDocument<T: Codable>(_ object: T,
                                    ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> {
        Log.d(ref.path)
        return Future<Bool, MoyangError> { promise in
            if let dict = object.dict {
                ref.updateData(dict, completion: { error in
                    if let error = error {
                        promise(.failure(.other(error)))
                    } else {
                        promise(.success(true))
                    }
                })
            } else {
                promise(.failure(.writingFailed))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateDocument(value: [String: Any],
                        ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> {
        Log.d(ref.path)
        return Future<Bool, MoyangError> { promise in
            ref.updateData(value, completion: { error in
                if let error = error {
                    promise(.failure(.other(error)))
                } else {
                    promise(.success(true))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    func appendValueToList(value: Any,
                           key: String,
                           ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> {
        Log.d(ref.path)
        return Future<Bool, MoyangError> { promise in
            ref.updateData([key: FieldValue.arrayUnion([value])]) { error in
                if let error = error {
                    promise(.failure(.other(error)))
                } else {
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func addListener<T: Codable>(ref: CollectionReference,
                                 type: T.Type) -> PassthroughSubject<T, MoyangError> {
        Log.d(ref.path)
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
        Log.d(ref.path)
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
    
    func addListener<T: Codable>(ref: DocumentReference,
                                 type: T.Type) -> PassthroughSubject<T, MoyangError> {
        Log.d(ref.path)
        let listener = PassthroughSubject<T, MoyangError>()
        
        ref.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                listener.send(completion: .failure(.other(error)))
            }
            let decoder = JSONDecoder()
            if let dict = documentSnapshot?.data(),
               let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                do {
                    let object = try decoder.decode(type, from: data)
                    listener.send(object)
                } catch let error {
                    listener.send(completion: .failure(.other(error)))
                }
            }
        }
        return listener
    }
    
    func fetchObject<T: Codable>(ref: CollectionReference,
                                 type: T.Type) -> AnyPublisher<T, MoyangError> {
        Log.d(ref.path)
        return Future<T, MoyangError> { promise in
            ref.addSnapshotListener { querySnapshot, error in
                if let error = error {
                    promise(.failure(MoyangError.other(error)))
                }
                
                
                if let query = querySnapshot {
                    let objectList = query.documents.compactMap { document in
                        try? document.data(as: T.self)
                    }
                    
                    if let object = objectList.last {
                        promise(.success(object))
                    } else {
                        promise(.failure(MoyangError.emptyData))
                    }
                } else {
                    promise(.failure(MoyangError.decodingFailed))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchObject<T: Codable>(ref: DocumentReference,
                                 type: T.Type) -> AnyPublisher<T, MoyangError> {
        Log.d(ref.path)
        return Future<T, MoyangError> { promise in
            ref.addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    promise(.failure(MoyangError.other(error)))
                }
                
                let decoder = JSONDecoder()
                if documentSnapshot?.data()?.isEmpty ?? true {
                    promise(.failure(MoyangError.noData))
                }
                if let dict = documentSnapshot?.data(),
                   let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                    do {
                        let object = try decoder.decode(type, from: data)
                        promise(.success(object))
                    } catch let error {
                        promise(.failure(MoyangError.other(error)))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}

class FirestoreServiceMock: FirestoreService {
    deinit { Log.i(self) }
    var store = Firestore.firestore()
    
    func addDocument<T>(_ object: T, ref: CollectionReference) -> AnyPublisher<Bool, MoyangError> where T: Decodable, T: Encodable {
        return Empty().eraseToAnyPublisher()
    }
    
    func addDocument<T>(_ object: T, ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> where T: Decodable, T: Encodable {
        return Empty().eraseToAnyPublisher()
    }
    
    func updateDocument<T>(_ object: T, ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> where T: Decodable, T: Encodable {
        return Empty().eraseToAnyPublisher()
    }
    
    func updateDocument(value: [String: Any], ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func appendValueToList(value: Any, key: String, ref: DocumentReference) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func addListener<T>(ref: CollectionReference, type: T.Type) -> PassthroughSubject<T, MoyangError> where T: Decodable, T: Encodable {
        return .init()
    }
    
    func addListener<T>(ref: CollectionReference, type: T.Type) -> PassthroughSubject<[T], MoyangError> where T: Decodable, T: Encodable {
        return .init()
    }
    
    func addListener<T>(ref: DocumentReference, type: T.Type) -> PassthroughSubject<T, MoyangError> where T: Decodable, T: Encodable {
        return .init()
    }
    
    func fetchObject<T>(ref: CollectionReference, type: T.Type) -> AnyPublisher<T, MoyangError> where T: Decodable, T: Encodable {
        return Empty().eraseToAnyPublisher()
    }
    
    func fetchObject<T>(ref: DocumentReference, type: T.Type) -> AnyPublisher<T, MoyangError> where T: Decodable, T: Encodable {
        return Empty().eraseToAnyPublisher()
    }
}
