//
//  GroupManageListVMMock.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/19.
//

import SwiftUI
import Combine

class GroupManageListVMMock: GroupManageListVM {
    override init() {
        super.init()
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    override func fetchItemList() {
    }
}
