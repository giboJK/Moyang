//
//  PrayCardVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class PrayCardVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    var id = ""
    
    @Published var pray: PraySubject
    
    init(pray: PraySubject) {
        self.pray = pray
        
        $pray
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
