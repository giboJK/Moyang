//
//  WorshipNoteUseCase.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import Foundation
import RxSwift
import RxCocoa

class WorshipNoteUseCase {
    let repo: WorshipRepo
    
    let notes = BehaviorRelay<[WorshipNote]>(value: [])
    var page: Int = 0
    var row: Int = 3
    
    var isNetworking = false
    // MARK: - Lifecycle
    init(repo: WorshipRepo) {
        self.repo = repo
    }
    
    func fetchWorshipNotes() {
        if isNetworking { return }
        isNetworking = true
        page = 0
        row = 5
        
        repo.fetchNotes(page: page, row: row) { [weak self] result in
            guard let self = self else { return }
            self.isNetworking = false
            switch result {
            case .success(let response):
                self.notes.accept(response.list)
            case .failure(let error):
                Log.e(error as Any)
            }
        }
    }
    
    func fetchMoreNotices() {
        if isNetworking { return }
        isNetworking = true
        page = row
        row += 5
        
        repo.fetchNotes(page: page, row: row) { [weak self] result in
            guard let self = self else { return }
            self.isNetworking = false
            switch result {
            case .success(let response):
                var list = self.notes.value
                list.append(contentsOf: response.list)
                self.notes.accept(list)
            case .failure(let error):
                Log.e(error as Any)
            }
        }
    }
    
    func addNote(pastor: String, bible: String, title: String, content: String, tags: [String]) {
        
    }
    
    func updateNote(id: String, pastor: String, bible: String, title: String, content: String, tags: [String]) {
        
    }
}
