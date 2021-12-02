//
//  NewCellPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/30.
//

import SwiftUI
import Combine

class NewCellPrayVM: ObservableObject, Identifiable {
    @Published var memberNewPrayList = [MemberNewPray]()
    
    init() {
    }
}

extension NewCellPrayVM {
    struct MemberNewPray: Hashable {
        
    }
}
