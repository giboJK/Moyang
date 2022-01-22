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
    private var year: String = ""
    
    init(service: FirestoreService) {
        self.service = service
    }
    
    func fetchGroupPreview() -> AnyPublisher<GroupPreview, MoyangError> {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func fetchGroupInfo() -> AnyPublisher<GroupInfo, MoyangError> {
        guard let myInfo = UserData.shared.myInfo else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        guard let yearSubString = myInfo.mainGroup.split(separator: "_").first else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        guard let groupSubString = myInfo.mainGroup.split(separator: "_").last else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        year = String(yearSubString)
        let group = String(groupSubString)
        let ref = service.store
            .collection(collectionName)
            .document("YD")
            .collection(year)
            .document(group)
        return service.fetchObject(ref: ref, type: GroupInfo.self)
    }
    
    func fetchMeetingInfo(parentGroup: String,
                          date: String) -> AnyPublisher<MeetingInfo, MoyangError> {
        let ref = service.store
            .collection(collectionName)
            .document("YD")
            .collection(year)
            .document(parentGroup)
            .collection("MEETING")
            .document(date)
        return service.fetchObject(ref: ref, type: MeetingInfo.self)
    }
    
    func add(_ date: Date,  _ data: GroupMemberPrayList, groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError> {
        guard let yearSubString = groupInfo.groupPath.split(separator: "_").first else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        guard let groupSubString = groupInfo.groupPath.split(separator: "_").last else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        let year = String(yearSubString)
        let group = String(groupSubString)
        let ref = service.store
            .collection(self.collectionName)
            .document("YD")
            .collection(year)
            .document(group)
            .collection("PRAY")
            .document(date.toString("yyyy-MM-dd hh:mm:ss.SSS"))
        
        return service.addDocument(data, ref: ref)
    }
    
    func addGroupPrayListListener() -> PassthroughSubject<GroupMemberPrayList, MoyangError> {
        var documentName = "TEST"
        if let userName = UserData.shared.userID {
            documentName = userName
        }
        let ref = service.store
            .collection(self.collectionName)
            .document(documentName)
            .collection("MY_PRAY")
        return service.addListener(ref: ref, type: GroupMemberPrayList.self)
    }
}
