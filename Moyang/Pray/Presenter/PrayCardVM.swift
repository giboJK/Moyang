//
//  PrayCardVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class PrayCardVM: ObservableObject, Identifiable {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var pray: Pray
    @Published var id: String
    @Published var prayType: PrayType
    
    init(pray: Pray) {
        self.pray = pray
        self.id = pray.id
        self.prayType = PrayType(rawValue: pray.type) ?? .my
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
