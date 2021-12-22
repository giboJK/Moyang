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
    
    private let store = Firestore.firestore()
    
    func fetchObject<T: Codable>(collection: String,
                                 type: T.Type) -> AnyPublisher<T, MoyangError> {
        return Future<T, MoyangError> { [weak self] promise in
            guard let self = self else { return }
            self.store.collection(collection)
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        promise(.failure(MoyangError.other(error)))
                    }
                    if let query = querySnapshot {
                        let objectList = query.documents.compactMap { document in
                            try? document.data(as: T.self)
                        }
                        _ = query.documents.compactMap { document in
                            Log.i(document.data())
                        }
                        if let object = objectList.first {
                            promise(.success(object))
                        } else {
                            promise(.failure(MoyangError.decodingFailed))
                        }
                    } else {
                        promise(.failure(MoyangError.emptyData))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func addListener<T: Codable>(collection: String,
                                 type: T.Type) -> PassthroughSubject<T, MoyangError> {
        let subject = PassthroughSubject<T, MoyangError>()
        self.store.collection(collection)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    subject.send(completion: .failure(.other(error)))
                }
                if let query = querySnapshot {
                    let objectList = query.documents.compactMap { document in
                        try? document.data(as: T.self)
                    }
                    _ = query.documents.compactMap { document in
                        Log.i(document.data())
                    }
                    if let object = objectList.first {
                        subject.send(object)
                    } else {
                        subject.send(completion: .failure(.decodingFailed))
                    }
                } else {
                    subject.send(completion: .failure(.emptyData))
                }
            }
        return subject
    }
    
    func fetchObjectList<T: Codable>(collection: String,
                                     type: T.Type) -> AnyPublisher<[T], MoyangError> {
            return Future<[T], MoyangError> { [weak self] promise in
                guard let self = self else { return }
                self.store.collection(collection)
                    .addSnapshotListener { querySnapshot, error in
                        if let error = error {
                            promise(.failure(MoyangError.other(error)))
                        }
                        if let query = querySnapshot {
                            let objectList = query.documents.compactMap { document in
                                try? document.data(as: T.self)
                            }
                            _ = query.documents.compactMap { document in
                                Log.i(document.data())
                            }
                            promise(.success(objectList))
                        } else {
                            promise(.failure(MoyangError.emptyData))
                        }
                    }
            }.eraseToAnyPublisher()
        }
}
