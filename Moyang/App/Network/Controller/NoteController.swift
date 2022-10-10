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
    func fetchNotes(page: Int, row: Int, completion: ((Result<FetchNotesResponse, Error>) -> Void)?) {
        
    }
    
    func addNote(pastor: String, bible: String, title: String, content: String, tags: [String],
                 completion: ((Result<AddNoteResponse, Error>) -> Void)?) {
        
    }
    
    func updateNote(id: String, pastor: String, bible: String, title: String, content: String, tags: [String],
                    completion: ((Result<UpdateNoteResponse, Error>) -> Void)?) {
        
    }
}
