//
//  ObservableObject.swift
//  Moyang
//
//  Created by 정김기보 on 2021/11/23.
//

import SwiftUI
import Combine

class CoordinatorObject: ObservableObject {
    
    @Published var cellPreviewVM: CellPreviewVM!
    @Published var cellMeetingVM: CellMeetingVM!
    
    init() {
        self.cellPreviewVM = CellPreviewVM(cellRepo: CellRepoImpl())
        self.cellMeetingVM = CellMeetingVM(cellRepo: CellRepoImpl())
    }
    
    func open(_ item: CellPrayListVM.MemberPrayItem) {
    }
}
