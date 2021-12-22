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
    
    @Published var cellPreview: CellPreview
    @Published var randomMemberList: [CellMember]
    
    var maxDisplayedMembers = 5
    
    init(cellPreview: CellPreview) {
        self.cellPreview = cellPreview
        maxDisplayedMembers = min(5, cellPreview.memberList.count)
        randomMemberList = cellPreview.memberList[randomPick: maxDisplayedMembers]
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
