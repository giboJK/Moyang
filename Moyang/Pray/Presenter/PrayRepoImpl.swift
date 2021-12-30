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
    private let service = FireStoreService()
    private let store = Firestore.firestore()
    private let collectionName = "PRAY_SUBJECT"
    
    
    func add(_ pray: PraySubject) -> AnyPublisher<Bool, MoyangError> {
        var documentName = "TEST"
        if let userName = UserData.shared.userID {
            documentName = userName
        }
        let ref = service.store
            .collection(self.collectionName)
            .document(documentName)
            .collection("MY_PRAY")
            .document(pray.createdTimestamp)
        return service.addDocument(pray, ref: ref)
    }
    
    func fetchPraySubject() -> AnyPublisher<PraySubject, MoyangError> {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func addPraySubjectListListener() -> PassthroughSubject<[PraySubject], MoyangError> {
        var documentName = "TEST"
        if let userName = UserData.shared.userID {
            documentName = userName
        }
        let ref = service.store
            .collection(self.collectionName)
            .document(documentName)
            .collection("MY_PRAY")
        return service.addListener(ref: ref, type: PraySubject.self)
    }
}
