//
//  CommunityMainRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import Foundation

protocol CommunityMainRepo {
    func fetchGroupInfo(community: String, groupID: String, completion: ((Result<GroupInfo, MoyangError>) -> Void)?)
    func fetchGroupList()
    func fetchMemberIndividualPray(member: Member, groupID: String, limit: Int, completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?)
    
    func addIndividualPray(data: GroupIndividualPray, myInfo: MemberDetail, completion: ((Result<Bool, MoyangError>) -> Void)?)
}
