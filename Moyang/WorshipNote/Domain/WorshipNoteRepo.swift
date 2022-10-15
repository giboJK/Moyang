//
//  WorshipNoteRepo.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import Foundation

protocol WorshipNoteRepo {
    // MARK: - Note
    func addNote(pastor: String, bible: String, title: String, content: String, tags: [String],
                 completion: ((Result<AddNoteResponse, Error>) -> Void)?)
    
    func updateNote(id: String, pastor: String, bible: String, title: String, content: String, tags: [String],
                    completion: ((Result<UpdateNoteResponse, Error>) -> Void)?)
    func deleteNote(id: String, completion: ((Result<BaseResponse, Error>) -> Void)?)
    func fetchNoteList(page: Int, row: Int, completion: ((Result<FetchNotesResponse, Error>) -> Void)?)
    func fetchNoteDetail(page: Int, row: Int, completion: ((Result<FetchNotesResponse, Error>) -> Void)?)
    
    // MARK: - Category
    func addCategory(name: String, color: String, completion: ((Result<AddNoteResponse, Error>) -> Void)?)
    
    func updateCategory(id: String, name: String, color: String, completion: ((Result<UpdateNoteResponse, Error>) -> Void)?)
    func deleteCategory(id: String, completion: ((Result<BaseResponse, Error>) -> Void)?)
    func fetchCategoryList(page: Int, row: Int, completion: ((Result<FetchNotesResponse, Error>) -> Void)?)
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
