//
//  CommunityMainRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation

protocol CommunityMainRepo {
    func fetchGroupSummary(myInfo: UserInfo, completion: ((Result<GroupSummary, MoyangError>) -> Void)?) 
    
    func fetchGroupInfo(community: String, groupID: String, completion: ((Result<GroupInfo, MoyangError>) -> Void)?)
}
