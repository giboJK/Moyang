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
    private let repo = SermonRepoImpl(service: FirestoreServiceImpl())
    
    @Published var itemList = [SermonItem]()
    
    init() {
        fetchSermonItem()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func fetchSermonItem() {
        repo.fetchSermonList()
            .sink(receiveCompletion: { completion in
                Log.i(completion)
            }, receiveValue: { list in
                var sermonList = [SermonItem]()
                list.forEach { sermon in
                    sermonList.append(SermonItem(sermon: sermon))
                }
                self.itemList = sermonList
            })
            .store(in: &cancellables)
    }
}

extension SermonListVM {
    struct SermonItem {
        let title: String
        let subtitle: String
        let bible: String
        let worship: String
        let date: String
        
        init(sermon: Sermon) {
            title = sermon.title
            subtitle = sermon.subtitle
            bible = sermon.bible
            worship = sermon.worship
            date = sermon.date
        }
    }
}
