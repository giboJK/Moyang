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
    func fetchMemberIndividualPray(memberAuth: String, email: String, groupID: String, limit: Int, start: String,
                                   completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?)
    
    
    func downloadSong(fileName: String, path: String, fileExt: String,
                      completion: ((Result<URL, MoyangError>) -> Void)?)
    
    func addReply(memberAuth: String,
                  email: String,
                  prayID: String,
                  reply: String,
                  date: String,
                  reactions: [PrayReaction],
                  order: Int,
                  completion: ((Result<PrayReply, MoyangError>) -> Void)?)
    
    func addPray(content: String, tags: [String], isSecret: Bool,completion: ((Result<Int, MoyangError>) -> Void)?)
}
