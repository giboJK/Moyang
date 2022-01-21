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
    func fetchGroupPreview() -> AnyPublisher<GroupPreview, MoyangError>
    func fetchGroupInfo() -> AnyPublisher<GroupInfo, MoyangError>
    func fetchMeetingInfo(parentGroup: String,
                          date: String) -> AnyPublisher<MeetingInfo, MoyangError>
    
    func add(_ data: [GroupMemberPray], groupInfo: GroupInfo) -> AnyPublisher<Bool, MoyangError>
    
    func addGroupPrayListListener() -> PassthroughSubject<[[GroupMemberPray]], MoyangError>
}
