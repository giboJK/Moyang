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
    private let service = FirestoreServiceImpl()
    private let collectionName = "DAILY"
    
    init() {
    }
    
    deinit {
        Log.i(self)
    }
    
    func fetchSummary() -> AnyPublisher<Summary, MoyangError> {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func addSummaryListener() -> PassthroughSubject<Summary, MoyangError> {
        let ref = service.store.collection(collectionName)
        return service.addListener(ref: ref,
                                   type: Summary.self)
    }
}
