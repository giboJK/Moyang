//
//  SermonCardVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/04.
//

import SwiftUI
import Combine

class SermonCardVM: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    
    @Published var item = SermonItem(title: "제목", subtitle: "부제목", bible: "성경구절", pastor: "설교자", date: "날짜", worshipName: "예배")
    
    init() {
        fetchSermonItem()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    private func fetchSermonItem() {
        
    }
}

extension SermonCardVM {
    struct SermonItem {
        let title: String
        let subtitle: String
        let bible: String
        let pastor: String
        let date: String
        let worshipName: String
        
        init(title: String,
             subtitle: String,
             bible: String,
             pastor: String,
             date: String,
             worshipName: String
        ) {
            self.title = title
            self.subtitle = subtitle
            self.bible = bible
            self.pastor = pastor
            self.date = date
            self.worshipName = worshipName
        }
    }
}

