//
//  AddNewGroupVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI
import Combine

class AddNewGroupVM: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    @Published var division = ""
    @Published var name = ""
    @Published var leaderName = ""
    @Published var memberList = [String]()
    
    init() {
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
