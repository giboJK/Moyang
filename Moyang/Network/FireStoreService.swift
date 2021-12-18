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
    static let shared = FireStoreService()
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
                        let summaryList = query.documents.compactMap { document in
                            try? document.data(as: T.self)
                        }
                        _ = query.documents.compactMap { document in
                            Log.i(document.data())
                        }
                        if let summary = summaryList.first {
                            promise(.success(summary))
                        } else {
                            promise(.failure(MoyangError.decodingFailed))
                        }
                    } else {
                        promise(.failure(MoyangError.emptyData))
                    }
                }
        }.eraseToAnyPublisher()
    }
}
