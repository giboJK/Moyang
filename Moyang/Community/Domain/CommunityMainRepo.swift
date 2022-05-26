//
//  CommunityMainRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation

protocol CommunityMainRepo {
    func fetchGroupInfo(community: String, groupID: String, completion: ((Result<GroupInfo, Error>) -> Void)?)
    func fetchGroupList()
}
