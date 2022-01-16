//
//  GroupRepoImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class GroupRepoImpl: GroupRepo {
    private let service: FirestoreService
    private let collectionName = "COMMUNITY"
    
    init(service: FirestoreService) {
        self.service = service
    }
    
    func fetchCellPreview() -> AnyPublisher<GroupPreview, Error> {
        return Just(DummyData().cellPreview)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        //        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func fetchGroupInfo() -> AnyPublisher<GroupInfo, Error> {
        //        return Just(DummyData().groupInfo)
        //            .setFailureType(to: Error.self)
        //            .receive(on: DispatchQueue.main)
        //            .eraseToAnyPublisher()
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    
    func add(_ cellPrayInfo: CellPrayInfo) -> AnyPublisher<Bool, MoyangError> {
        var documentName = "TEST"
        if let userName = UserData.shared.userID {
            documentName = userName
        }
        let ref = service.store
            .collection(self.collectionName)
            .document(documentName)
            .collection("MY_PRAY")
            .document(cellPrayInfo.createdTimestamp)
        return service.addDocument(cellPrayInfo, ref: ref)
    }
    
    func addCellPrayListListener() -> PassthroughSubject<CellPrayInfo, MoyangError> {
        var documentName = "TEST"
        if let userName = UserData.shared.userID {
            documentName = userName
        }
        let ref = service.store
            .collection(self.collectionName)
            .document(documentName)
            .collection("MY_PRAY")
        return service.addListener(ref: ref, type: CellPrayInfo.self)
    }
}
