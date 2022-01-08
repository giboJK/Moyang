//
//  DailyRepoImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class DailyRepoImpl: DailyRepo {
    private let service = FirestoreServiceImpl()
    private let firstCollectionName = "DAILY"
    
    init() {
    }
    
    deinit {
        Log.i(self)
    }
    
    func fetchDailyPreview() -> AnyPublisher<DailyPreview, MoyangError> {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func addDailyPreviewListener() -> PassthroughSubject<DailyPreview, MoyangError> {
        let ref = service.store.collection(firstCollectionName)
        return service.addListener(ref: ref,
                                   type: DailyPreview.self)
    }
    
    func addDailyPreview(_ data: DailyPreview) -> AnyPublisher<Bool, MoyangError> {
        let ref = createRef()
        return service.addDocument(data, ref: ref)
    }
    
    private func createRef() -> CollectionReference {
        var documentName = "teoeirm@gmail.com"
        if let userID = UserData.shared.userID {
            documentName = userID
        }
        
        return service.store
            .collection(self.firstCollectionName)
    }
    
    private func -> DocumentReference {
        var documentName = "teoeirm@gmail.com"
        if let userID = UserData.shared.userID {
            documentName = userID
        }
        
        return service.store
            .collection(self.firstCollectionName)
            .document(documentName)
    }
}
