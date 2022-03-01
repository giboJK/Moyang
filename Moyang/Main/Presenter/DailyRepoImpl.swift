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
    
    func fetchGroupPreview() -> AnyPublisher<GroupPreview, MoyangError> {
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
    
    func updateGroupPray(docment: String, value: [String : Any], groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError> {
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
