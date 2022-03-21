//
//  GroupPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/19.
//

import SwiftUI
import Combine

class GroupPrayVM: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    
    @Published var title: String = ""
    @Published var pray: String = ""
    @Published var time: String = "00:00"
    
    init(title: String, pray: String) {
        self.title = title
        self.pray = pray
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
