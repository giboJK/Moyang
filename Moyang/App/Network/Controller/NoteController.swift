//
//  NoteController.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import Foundation

class NoteController {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension NoteController: WorshipNoteRepo {

    // MARK: - Note
    func addNote(pastor: String, bible: String, title: String, content: String, tags: [String],
                 completion: ((Result<AddNoteResponse, Error>) -> Void)?) {
        
    }
    
    func updateNote(id: String, pastor: String, bible: String, title: String, content: String, tags: [String],
                    completion: ((Result<UpdateNoteResponse, Error>) -> Void)?) {
        
    }
    func deleteNote(id: String, completion: ((Result<BaseResponse, Error>) -> Void)?) {
        
    }
    
    func fetchNoteDetail(page: Int, row: Int, completion: ((Result<FetchNotesResponse, Error>) -> Void)?) {
        
    }
    
    func fetchNoteList(page: Int, row: Int, completion: ((Result<FetchNotesResponse, Error>) -> Void)?) {
        
    }
    
    
    // MARK: - Category
    func addCategory(name: String, color: String, completion: ((Result<AddNoteResponse, Error>) -> Void)?) {
        
    }
    
    func updateCategory(id: String, name: String, color: String, completion: ((Result<UpdateNoteResponse, Error>) -> Void)?) {
        
    }
    
    func deleteCategory(id: String, completion: ((Result<BaseResponse, Error>) -> Void)?) {
        
    }
    
    func fetchCategoryList(userId: String, page: Int, row: Int, completion: ((Result<FetchCategoryListResponse, Error>) -> Void)?) {
        let url = networkService.makeUrl(path: NetConst.NoteAPI.fetchCategoryList)
        let request = networkService.makeRequest(url: url,
                                                 method: .post,
                                                 parameters: ["user_id": userId,
                                                              "page": page,
                                                              "row": row])
        
        networkService.requestAPI(request: request,
                                  type: FetchCategoryListResponse.self,
                                  token: nil) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
