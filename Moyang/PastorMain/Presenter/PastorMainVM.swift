//
//  PastorMainVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/01/19.
//

import SwiftUI
import Combine

class PastorMainVM: ObservableObject, Identifiable {
    private var cancellables = Set<AnyCancellable>()
    
    init() {
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}

