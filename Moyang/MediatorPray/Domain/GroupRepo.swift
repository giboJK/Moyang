//
//  GroupRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import Foundation

protocol GroupRepo {
    func registerGroup(userID: String, name: String, desc: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    func fetchGroupList(page: Int, row: Int, completion: ((Result<GroupSearchedGroupListResponse, MoyangError>) -> Void)?)
    
    func fetchMyGroupSummary(userID: String, completion: ((Result<GroupMediatorInfoListResponse, MoyangError>) -> Void)?)
    
    func fetchGroupEvent(groupID: String, isWeek: Bool, date: String, completion: ((Result<GroupEventResponse, MoyangError>) -> Void)?)
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
