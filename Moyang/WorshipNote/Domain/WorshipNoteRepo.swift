//
//  WorshipNoteRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import Foundation

protocol WorshipNoteRepo {
    func fetchNotes(page: Int, row: Int, completion: ((Result<FetchNotesResponse, Error>) -> Void)?)
    
    func addNote(pastor: String, bible: String, title: String, content: String, tags: [String],
                 completion: ((Result<AddNoteResponse, Error>) -> Void)?)
    
    func updateNote(id: String, pastor: String, bible: String, title: String, content: String, tags: [String],
                    completion: ((Result<UpdateNoteResponse, Error>) -> Void)?)
}

class AddNoteResponse: BaseResponse {
    let data: WorshipNote
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(WorshipNote.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class UpdateNoteResponse: BaseResponse {
    let data: WorshipNote
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(WorshipNote.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class FetchNotesResponse: BaseResponse {
    let list: [WorshipNote]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        list = try container.decode([WorshipNote].self, forKey: .list)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case list = "data"
    }
}
