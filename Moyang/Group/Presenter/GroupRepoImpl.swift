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
import Foundation

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
        guard let yearSubString = groupInfo.createdDate.split(separator: ".").first else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        let year = String(yearSubString)
        let ref = service.store
            .collection(self.collectionName)
            .document("YD")
            .collection(year)
            .document(groupInfo.id)
            .collection("PRAY")
            .document(date.toString("yyyy-MM-dd hh:mm:ss"))
        
        return service.addDocument(data, ref: ref)
    }
    
    func addGroupPrayListListener(groupInfo: GroupInfo) -> PassthroughSubject<[GroupMemberPrayList], MoyangError> {
        let listener = PassthroughSubject<[GroupMemberPrayList], MoyangError>()
        guard let yearSubString = groupInfo.createdDate.split(separator: ".").first else {
            listener.send(completion: .failure(.invalidURL))
            return listener
        }
        let year = String(yearSubString)
        let ref = service.store
            .collection(self.collectionName)
            .document("YD")
            .collection(year)
            .document(groupInfo.id)
            .collection("PRAY")
        return service.addListener(ref: ref, type: GroupMemberPrayList.self)
    }
    
    func updateGroupPray(docment: String,
                         value: [String: Any],
                         groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError> {
        guard let yearSubString = groupInfo.createdDate.split(separator: ".").first else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        let year = String(yearSubString)
        let ref = service.store
            .collection(self.collectionName)
            .document("YD")
            .collection(year)
            .document(groupInfo.id)
            .collection("PRAY")
            .document(docment)
        
        return service.updateDocument(value: value, ref: ref)
    }
    
    func addNewGroup(groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError> {
        let ref = service.store
            .collection(self.collectionName)
            .document("YD")
            .collection("2022")
            .document(groupInfo.id)
        
        // TODO: - 일단 루프 돌면서 업데이트를 고고
        groupInfo.leaderList.forEach { member in
            let ref = service.store
                .collection("USER")
                .document("AUTH")
                .collection("EMAIL")
                .document(member.email)
            _ = service.appendValueToList(value: groupInfo.id,
                                          key: "group_list",
                                          ref: ref)
        }
        
        groupInfo.memberList.forEach { member in
            let ref = service.store
                .collection("USER")
                .document("AUTH")
                .collection("EMAIL")
                .document(member.email)
            _ = service.appendValueToList(value: groupInfo.id,
                                          key: "group_list",
                                          ref: ref)
        }
        
        return service.addDocument(groupInfo, ref: ref)
    }
}
