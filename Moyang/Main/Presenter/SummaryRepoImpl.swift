//
//  SummaryRepoImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class SummaryRepoImpl: SummaryRepo {
    private let store = Firestore.firestore()
    private let collectionName = "DAILY"
    
    init() {
        
    }
    
    func fetchSummary() -> AnyPublisher<Summary, Error> {
//        return Empty(completeImmediately: false).eraseToAnyPublisher()
        return Future<Summary, Error> { [weak self] promise in
            guard let self = self else { return }
            self.store.collection(self.collectionName)
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        promise(.failure(MoyangError.other(error)))
                    }
                    if let query = querySnapshot {
                        let summaryList = query.documents.compactMap { document in
                            try? document.data(as: Summary.self)
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
