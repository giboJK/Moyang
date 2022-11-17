//
//  GroupRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import Foundation

protocol GroupRepo {
    func registerGroup(userID: String, name: String, desc: String, completion: ((Result<RegisterGroupResponse, MoyangError>) -> Void)?)
    
    func fetchGroupList(page: Int, row: Int)
    
    func fetchMyGroupList(userID: String, completion: ((Result<GroupInfoListResponse, MoyangError>) -> Void)?)
    
    func fetchGroupEvent(groupID: String, isWeek: Bool, date: String, completion: ((Result<GroupEventResponse, MoyangError>) -> Void)?)
}

class RegisterGroupResponse: BaseResponse {
    let data: GroupInfo
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(GroupInfo.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}


class GroupInfoListResponse: BaseResponse {
    let data: [GroupInfo]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([GroupInfo].self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
