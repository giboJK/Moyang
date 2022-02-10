//
//  SermonRepoImpl.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/10.
//

import Foundation
import Combine

class SermonRepoImpl: SermonRepo {
    private let service: FirestoreService
    private let collectionName = "COMMUNITY"
    private var year: String = ""
    
    init(service: FirestoreService) {
        self.service = service
    }
    
    func add(_ sermon: Sermon) -> AnyPublisher<Bool, MoyangError> {
        let userInfo = UserData.shared.myInfo!
        let mainGroup = userInfo.mainGroup
        guard let yearSubString = mainGroup.split(separator: "_").first else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        guard let groupSubString = mainGroup.split(separator: "_").last else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        let year = String(yearSubString)
        let group = String(groupSubString)
        let ref = service.store
            .collection(collectionName)
            .document("YD")
            .collection(year)
            .document(group)
            .collection("SERMON")
            .document(sermon.date)
        
        return service.addDocument(sermon, ref: ref)
    }
}
