//
//  PrayRepoImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class PrayRepoImpl: PrayRepo {
    private let store = Firestore.firestore()
    private let collectionName = "PRAY_SUBJECT"
    
    
    func add(_ pray: PraySubject) {
        do {
            var documentName = "TEST"
            if let userName = UserData.shared.userID {
                documentName = userName
            }
            _ = try store
                .collection(collectionName)
                .document(documentName)
                .collection(pray.createdTimestamp)
                .addDocument(from: pray)
        } catch {
            Log.e(MoyangError.writingFailed)
        }
    }
    
    
    func fetchPraySubject() -> AnyPublisher<PraySubject, MoyangError> {
        return Future<PraySubject, MoyangError> { [weak self] promise in
            guard let self = self else { return }
            self.store.collection(self.collectionName)
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        promise(.failure(MoyangError.other(error)))
                    }
                    if let query = querySnapshot {
                        let summaryList = query.documents.compactMap { document in
                            try? document.data(as: PraySubject.self)
                        }
                        if let summary = summaryList.first {
                            promise(.success(summary))
                        } else {
                            promise(.failure(MoyangError.emptyData))
                        }
                    } else {
                        promise(.failure(MoyangError.decodingFailed))
                    }
                }
        }.eraseToAnyPublisher()
    }
}
