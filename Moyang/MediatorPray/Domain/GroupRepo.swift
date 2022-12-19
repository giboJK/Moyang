//
//  GroupRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import Foundation

protocol GroupRepo {
    func registerGroup(userID: String, name: String, desc: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    // MARK: - Fetch
    func fetchGroupList(userID: String, page: Int, row: Int, completion: ((Result<GroupSearchedGroupListResponse, MoyangError>) -> Void)?)
    
    func fetchMyGroupSummary(userID: String, completion: ((Result<GroupMediatorInfoListResponse, MoyangError>) -> Void)?)
    
    func fetchGroupEvent(groupID: String, isWeek: Bool, date: String, completion: ((Result<GroupEventResponse, MoyangError>) -> Void)?)
    
    func fetchGroupDetail(groupID: String, userID: String, completion: ((Result<GroupDetailResponse, MoyangError>) -> Void)?)
    
    func fetchGroupMemberPrayList(groupID: String, userID: String, page: Int, row: Int,
                                  completion: ((Result<GroupMemberPrayListResponse, MoyangError>) -> Void)?)
    
    func fetchPrayDetail(prayID: String, completion: ((Result<PrayDetailResponse, MoyangError>) -> Void)?)
    
    func fetchMyPrayList(userID: String, page: Int, row: Int, completion: ((Result<[GroupMemberPray], MoyangError>) -> Void)?)
    
    
    // MARK: - Etc
    func exitGroup(groupID: String, userID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    func joinGroup(groupID: String, userID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    func acceptGroup(reqID: String, isAccepted: Bool, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    // MARK: - Add
    func addReply(prayID: String, myID: String, content: String, completion: ((Result<AddReplyResponse, MoyangError>) -> Void)?)
}

class GroupMediatorInfoListResponse: BaseResponse {
    let data: [GroupMediatorInfo]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([GroupMediatorInfo].self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class GroupSearchedGroupListResponse: BaseResponse {
    let data: [GroupSearchedInfo]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([GroupSearchedInfo].self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class GroupDetailResponse: BaseResponse {
    let data: GroupDetail
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(GroupDetail.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class GroupMemberPrayListResponse: BaseResponse {
    let data: [GroupMemberPray]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([GroupMemberPray].self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class AddReplyResponse: BaseResponse {
    let data: PrayReply
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(PrayReply.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
