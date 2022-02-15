//
//  SermonListVMMock.swift
//  Moyang
//
//  Created by kibo on 2022/02/06.
//

import SwiftUI
import Combine

class SermonListVMMock: SermonListVM {
    
    override init() {
        super.init()
        fetchSermonItem()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    private func fetchSermonItem() {
        
    }
}
