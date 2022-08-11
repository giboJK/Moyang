//
//  GroupPrayRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation

protocol PrayRepo {
    func addPray(userID: String, groupID: String, content: String, tags: [String], isSecret: Bool,
                 completion: ((Result<AddPrayResponse, MoyangError>) -> Void)?)
    func updatePray(prayID: String, pray: String, tags: [String], isSecret: Bool,
                    completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    func fetchPrayList(groupID: String, userID: String, isMe: Bool, order: String, page: Int, row: Int,
                       completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?)
    
    // 전체 인원 기도 가져올 때
    func fetchPrayAll(groupID: String, userID: String, order: String, page: Int, row: Int,
                      completion: ((Result<[GroupIndividualPray], MoyangError>) -> Void)?)
    
    func deletePray(prayID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    func addReaction(userID: String, prayID: String, type: Int, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    func addAmen(userID: String, groupID: String, time: Int, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    
    func downloadSong(fileName: String, path: String, fileExt: String,
                      completion: ((Result<URL, MoyangError>) -> Void)?)
    
}
