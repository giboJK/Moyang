//
//  CommunityListService.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class CommunityListService: SermonRepo & GroupRepo {
    func add(_ sermon: Sermon) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func fetchSermonList() -> PassthroughSubject<[Sermon], MoyangError> {
        return .init()
    }
    
    func fetchLatestSermon() -> AnyPublisher<Sermon, MoyangError> {
        guard let myInfo = UserData.shared.myInfo else {
            return Empty().eraseToAnyPublisher()
        }
        guard let groupInfo = UserData.shared.groupInfo else {
            return Empty().eraseToAnyPublisher()
        }
        let ref = service.store
            .collection("COMMUNITY")
            .document(myInfo.community)
            .collection("2022")
            .document(groupInfo.parentGroup)
            .collection("SERMON")
        return service.fetchObject(ref: ref, type: Sermon.self)
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
            .document(myInfo.community)
            .collection("2022")
            .document(groupID)
        return service.fetchObject(ref: ref, type: GroupInfo.self)
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
    
    func fetchLatestGroupPray() -> AnyPublisher<GroupMemberPray, MoyangError> {
        guard let myInfo = UserData.shared.myInfo else {
            return Empty().eraseToAnyPublisher()
        }
        guard let groupInfo = UserData.shared.groupInfo else {
            return Empty().eraseToAnyPublisher()
        }
        let ref = service.store
            .collection("COMMUNITY")
            .document(myInfo.community)
            .collection("2022")
            .document(groupInfo.parentGroup)
            .collection("PRAY")
        return service.fetchObject(ref: ref, type: GroupMemberPray.self)
    }
    
    func updateGroupPray(docment: String, value: [String: Any], groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func addNewGroup(groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError> {
        return Empty().eraseToAnyPublisher()
    }
    
    private let service = FirestoreServiceImpl()
    
    init() {
    }
    
    deinit {
        Log.i(self)
    }
    
}
