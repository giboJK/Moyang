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
    func fetchMemberIndividualPray(memberAuth: String, email: String, groupID: String, limit: Int, start: String,
                                   completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?)
    func fetchMemberNonSecretIndividualPray(memberAuth: String, email: String, groupID: String, limit: Int, start: String,
                                            completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?)
    
    func addIndividualPray(data: GroupIndividualPray, myInfo: MemberDetail, completion: ((Result<Bool, MoyangError>) -> Void)?)
    
    func downloadSong(fileName: String, path: String, fileExt: String,
                      completion: ((Result<URL, MoyangError>) -> Void)?)
    
    func amen(time: Int, groupID: String, myInfo: MemberDetail, completion: ((Result<Bool, MoyangError>) -> Void)?)
    
    func addReaction(memberAuth: String, email: String, prayID: String, myInfo: MemberDetail, reaction: String, reactions: [PrayReaction],
                     completion: ((Result<[PrayReaction], MoyangError>) -> Void)?)
}
