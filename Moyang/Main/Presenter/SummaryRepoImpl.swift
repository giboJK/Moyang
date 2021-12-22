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
    private let service = FireStoreService()
    private let collectionName = "DAILY"
    
    init() {
    }
    
    deinit {
        Log.i(self)
    }
    
    func fetchSummary() -> AnyPublisher<Summary, MoyangError> {
        //        return Empty(completeImmediately: false).eraseToAnyPublisher()
        return service.fetchObject(collection: collectionName,
                                   type: Summary.self)
    }
    
    func addSummaryListener() -> PassthroughSubject<Summary, MoyangError> {
        return service.addListener(collection: collectionName,
                                   type: Summary.self)
    }
}
