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
        let ref = service.store
            .collection(collectionName)
            .document("YD")
            .collection("2022")
            .document(mainGroup)
            .collection("SERMON")
            .document(sermon.date)
        
        return service.addDocument(sermon, ref: ref)
    }
    
    func fetchSermonList() -> PassthroughSubject<[Sermon], MoyangError> {
        let userInfo = UserData.shared.myInfo!
        // TODO: parentGroup로 바꾸어야 함
        let mainGroup = userInfo.mainGroup
        guard let yearSubString = mainGroup.split(separator: "_").first else {
            Log.e("")
            return PassthroughSubject<[Sermon], MoyangError>()
        }
        guard let groupSubString = mainGroup.split(separator: "_").last else {
            Log.e("")
            return PassthroughSubject<[Sermon], MoyangError>()
        }
        let year = String(yearSubString)
        let group = String(groupSubString)
        
        let ref = service.store
            .collection(collectionName)
            .document("YD")
            .collection(year)
            .document(group)
            .collection("SERMON")
        
        return service.addListener(ref: ref, type: Sermon.self)
    }
}
