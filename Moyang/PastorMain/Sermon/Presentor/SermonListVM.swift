//
//  SermonListVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import Combine

class SermonListVM: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    @Published var itemList = [SermonItem]()
    
    init() {
        fetchSermonItem()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func fetchSermonItem() {
    }
}

extension SermonListVM {
    struct SermonItem: Identifiable {
        let id: String
        let title: String
        let subtitle: String
        let bible: String
        let worship: String
        let date: String
        
        init(sermon: Sermon) {
            id = UUID().uuidString
            title = sermon.title
            subtitle = sermon.subtitle
            bible = sermon.bible
            worship = sermon.worship
            date = sermon.date
        }
    }
}
