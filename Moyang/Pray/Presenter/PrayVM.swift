//
//  PrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/16.
//

import SwiftUI
import Combine

class PrayVM: ObservableObject, Identifiable {
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
