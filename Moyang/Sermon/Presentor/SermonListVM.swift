//
//  SermonListVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import Combine

class SermonListVM: ObservableObject {
    var disposables = Set<AnyCancellable>()
    
    @Published var itemList = [SermonListItem]()
    
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

extension SermonListVM {
    struct SermonListItem {
        
    }
}
