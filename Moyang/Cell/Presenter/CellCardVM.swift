//
//  CellCardVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/18.
//

import SwiftUI
import Combine

class CellCardVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    var id = ""
    
    @Published var cellPreview: CellPreview
    
    init(cellPreview: CellPreview) {
        self.cellPreview = cellPreview
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
