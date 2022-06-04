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
    
    func fetchGroupInfo() -> AnyPublisher<GroupInfo, MoyangError> {
        guard let myInfo = UserData.shared.myInfo else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        guard let groupID = myInfo.groupList.first else {
            return Empty().eraseToAnyPublisher()
        }
        let ref = service.store
            .collection("COMMUNITY")
            .document(myInfo.community.uppercased())
            .collection("2022")
            .document(groupID)
        return service.fetchObject(ref: ref, type: GroupInfo.self)
    }
    func fetchGroupInfoList(groupList: [String]) -> AnyPublisher<[GroupInfo], MoyangError> {
        guard let myInfo = UserData.shared.myInfo else {
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        let query = service.store
            .collection("COMMUNITY")
            .document(myInfo.community.uppercased())
            .collection("2022")
            .whereField("id", in: groupList)
            
        return service.fetchDocumentsWithQuery(query: query, type: GroupInfo.self)
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
    
    func updateIndividualPray(_ data: GroupIndividualPray, myInfo: MemberDetail) -> AnyPublisher<Bool, MoyangError> {
        let ref = service.store
            .collection("USER")
            .document("AUTH")
            .collection(myInfo.authType)
            .document(myInfo.email)
            .collection("PRAY")
            .document(data.id)
        
        return service.updateDocument(data, ref: ref)
    }
    
    func fetchLatestGroupPray() -> AnyPublisher<GroupMemberPrayList, MoyangError> {
        return Empty().eraseToAnyPublisher()
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
    func fetchIndividualPrayList(member: Member, groupID: String, limit: Int) -> AnyPublisher<[GroupIndividualPray], MoyangError> {
        let query = service.store
            .collection("USER")
            .document("AUTH")
            .collection(member.auth)
            .document(member.email)
            .collection("PRAY")
            .whereField("group_id", in: [groupID])
            .order(by: "date", descending: true)
            .limit(to: limit)
            
        return service.fetchDocumentsWithQuery(query: query, type: GroupIndividualPray.self)
    }
    
    func add(_ data: GroupIndividualPray, myInfo: MemberDetail) -> AnyPublisher<Bool, MoyangError> {
        let ref = service.store
            .collection("USER")
            .document("AUTH")
            .collection(myInfo.authType)
            .document(myInfo.email)
            .collection("PRAY")
            .document(data.id)
        
        return service.addDocument(data, ref: ref)
    }
}

class GroupRepoMock: GroupRepo {
    func updateIndividualPray(_ data: GroupIndividualPray, myInfo: MemberDetail) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func fetchGroupInfoList(groupList: [String]) -> AnyPublisher<[GroupInfo], MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func fetchGroupInfo() -> AnyPublisher<GroupInfo, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func fetchMeetingInfo(parentGroup: String, date: String) -> AnyPublisher<MeetingInfo, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func add(_ date: Date, _ data: GroupMemberPrayList, groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func addGroupPrayListListener(groupInfo: GroupInfo) -> PassthroughSubject<[GroupMemberPrayList], MoyangError> {
        return .init()
    }
    
    func fetchLatestGroupPray() -> AnyPublisher<GroupMemberPrayList, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func updateGroupPray(docment: String, value: [String: Any], groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func addNewGroup(groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    func fetchIndividualPrayList(member: Member, groupID: String, limit: Int) -> AnyPublisher<[GroupIndividualPray], MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    func add(_ data: GroupIndividualPray, myInfo: MemberDetail) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
}
