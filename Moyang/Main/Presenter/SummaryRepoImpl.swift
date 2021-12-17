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
    
    func fetchSummary() -> AnyPublisher<Summary, MoyangError> {
//        return Empty(completeImmediately: false).eraseToAnyPublisher()
        return FireStoreService.shared.fetchObject(collection: collectionName,
                                                   type: Summary.self)
    }
}
