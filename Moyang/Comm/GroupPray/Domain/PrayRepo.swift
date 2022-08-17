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
    
    func addReaction(userID: String, prayID: String, type: Int, completion: ((Result<AddPrayReactionResponse, MoyangError>) -> Void)?)
    
    func addAnswer(userID: String, prayID: String, answer: String, completion: ((Result<AddPrayAnswerResponse, MoyangError>) -> Void)?)
    
    func addReply(userID: String, prayID: String, reply: String, completion: ((Result<AddPrayReplyResponse, MoyangError>) -> Void)?)
    
    func addChange(prayID: String, content: String, completion: ((Result<AddPrayChangeResponse, MoyangError>) -> Void)?)
    
    
    func addAmen(userID: String, groupID: String, time: Int, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    
    func downloadSong(fileName: String, path: String, fileExt: String,
                      completion: ((Result<URL, MoyangError>) -> Void)?)
    
}

// MARK: - Response
class AddPrayResponse: BaseResponse {
    let data: GroupIndividualPray
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(GroupIndividualPray.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class AddPrayAnswerResponse: BaseResponse {
    let data: PrayAnswer
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(PrayAnswer.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class AddPrayReplyResponse: BaseResponse {
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

class AddPrayReactionResponse: BaseResponse {
    let data: PrayReaction
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(PrayReaction.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class AddPrayChangeResponse: BaseResponse {
    let data: PrayChange
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(PrayChange.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
