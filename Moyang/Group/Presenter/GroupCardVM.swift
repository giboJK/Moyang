//
//  GroupCardVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/12/18.
//

import SwiftUI
import Combine

class GroupCardVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var preview: GroupPreview
    @Published var randomMemberList: [GroupMember]
    
    var maxDisplayedMembers = 7
    
    init(preview: GroupPreview) {
        self.preview = preview
        maxDisplayedMembers = min(5, preview.memberList.count)
        randomMemberList = preview.memberList[randomPick: maxDisplayedMembers]
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
