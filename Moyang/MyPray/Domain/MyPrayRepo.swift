//
//  GroupPrayRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import Foundation

protocol MyPrayRepo {
    
    // MARK: - Add
    func addPray(userID: String, category: String, content: String, groupID: String, completion: ((Result<AddPrayResponse, MoyangError>) -> Void)?)
    
    func addAnswer(prayID: String, answer: String, completion: ((Result<AddPrayAnswerResponse, MoyangError>) -> Void)?)
    
    func addChange(prayID: String, change: String, completion: ((Result<AddPrayChangeResponse, MoyangError>) -> Void)?)
    
    func addPrayGroupInfo(groupID: String, prayID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    
    // MARK: - Update
    func updatePray(prayID: String, category: String, content: String, groupID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    func updateChange(changeID: String, change: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    func updateAnswer(answerID: String, answer: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    
    // MARK: - Delete
    func deletePray(prayID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    func deleteChange(changeID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    func deleteAnswer(answerID: String, completion: ((Result<BaseResponse, MoyangError>) -> Void)?)
    
    
    // MARK: - Fetch
    func fetchPrayDetail(prayID: String, completion: ((Result<PrayDetailResponse, MoyangError>) -> Void)?)
    
    func fetchPrayList(userID: String, page: Int, row: Int, completion: ((Result<[MyPray], MoyangError>) -> Void)?)
    
    func fetchSummary(userID: String, date: String, completion: ((Result<PraySummaryResponse, MoyangError>) -> Void)?)
    
    func fetchMyGroupList(userID: String, completion: ((Result<MyGroupListResponse, MoyangError>) -> Void)?)
    
    // MARK: - Download
    func downloadSong(fileName: String, path: String, fileExt: String,
                      completion: ((Result<URL, MoyangError>) -> Void)?)
    
}

// MARK: - Response
class PraySummaryResponse: BaseResponse {
    let data: MyPraySummary
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(MyPraySummary.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class PrayDetailResponse: BaseResponse {
    let data: PrayDetail
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(PrayDetail.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

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

struct PrayTag: Codable {
    let content: String
    let type: Int
    
    enum CodingKeys: String, CodingKey {
        case content
        case type
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
    let desc: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case desc
    }
}
