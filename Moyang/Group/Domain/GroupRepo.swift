//
//  GroupRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/19.
//  Copyright © 2021 정김기보. All rights reserved.
//

import Foundation
import Combine

protocol GroupRepo {
    func fetchGroupInfo() -> AnyPublisher<GroupInfo, MoyangError>
    func fetchMeetingInfo(parentGroup: String,
                          date: String) -> AnyPublisher<MeetingInfo, MoyangError>
    
    func add(_ date: Date, _ data: GroupMemberPrayList, groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError>
    
    func addGroupPrayListListener(groupInfo: GroupInfo) -> PassthroughSubject<[GroupMemberPrayList], MoyangError>
    
    func fetchLatestGroupPray() -> AnyPublisher<GroupMemberPrayList, MoyangError>
    func updateGroupPray(docment: String,
                         value: [String: Any],
                         groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError>
    
    
    //
    func addNewGroup(groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError>
}
