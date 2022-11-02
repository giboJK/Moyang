//
//  GroupPrayRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation

protocol MyPrayRepo {
    
    // Add
    func addPray(userID: String, groupID: String, content: String, tags: [String], isSecret: Bool,
                 completion: ((Result<AddPrayResponse, MoyangError>) -> Void)?)
    
    func addReaction(userID: String, prayID: String, type: Int, completion: ((Result<AddPrayReactionResponse, MoyangError>) -> Void)?)
    
    func addAnswer(userID: String, prayID: String, answer: String, completion: ((Result<AddPrayAnswerResponse, MoyangError>) -> Void)?)
    
    func addReply(userID: String, prayID: String, reply: String, completion: ((Result<AddPrayReplyResponse, MoyangError>) -> Void)?)
    
    func addChange(prayID: String, content: String, completion: ((Result<AddPrayChangeResponse, MoyangError>) -> Void)?)
    
    
    func addAmen(userID: String, groupID: String, time: Int, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    // Update
    func updatePray(prayID: String, pray: String, tags: [String], isSecret: Bool,
                    completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    func updateReply(replyID: String, reply: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    // Delete
    func deletePray(prayID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    func deleteReply(replyID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    
    // Fetch
    func fetchPrayList(groupID: String, userID: String, isMe: Bool, order: String, page: Int, row: Int,
                       completion: ((Result<[MyPray], MoyangError>) -> Void)?)
    func fetchPray(prayID: String, completion: ((Result<MyPray, MoyangError>) -> Void)?)
    
    func fetchTagAutocomplete(tag: String, completion: ((Result<TagAutocompleteResponse, MoyangError>) -> Void)?)
    
    func fetchMyGroupList(userID: String, completion: ((Result<MyGroupListResponse, MoyangError>) -> Void)?)
    
    // 전체 인원 기도 가져올 때
    func fetchPrayAll(groupID: String, userID: String, order: String, page: Int, row: Int,
                      completion: ((Result<[MyPray], MoyangError>) -> Void)?)
    
    func fetchGroupAcitvity(groupID: String, isWeek: Bool, date: String, completion: ((Result<GroupEventResponse, MoyangError>) -> Void)?)
    
    // Search
    func searchPrays(tag: String, groupID: String, completion: ((Result<PraySearchResponse, MoyangError>) -> Void)?)
    
    
    // Download
    func downloadSong(fileName: String, path: String, fileExt: String,
                      completion: ((Result<URL, MoyangError>) -> Void)?)
    
}

// MARK: - Response
class AddPrayResponse: BaseResponse {
    let data: MyPray
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(MyPray.self, forKey: .data)
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

class TagAutocompleteResponse: BaseResponse {
    let tags: [PrayTag]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tags = try container.decode([PrayTag].self, forKey: .tags)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case tags
    }
}

struct PrayTag: Codable {
    let content: String
    let type: Int
    
    enum CodingKeys: String, CodingKey {
        case content
        case type
    }
}

class PraySearchResponse: BaseResponse {
    let prays: [SearchedPray]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prays = try container.decode([SearchedPray].self, forKey: .prays)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case prays
    }
}

class MyGroupListResponse: BaseResponse {
    let groups: [MyGroup]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        groups = try container.decode([MyGroup].self, forKey: .groups)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case groups
    }
}

struct MyGroup: Codable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
