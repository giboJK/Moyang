//
//  GroupPrayingVMMock.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/19.
//

import SwiftUI
import Combine

class GroupPrayingVMMock: GroupPrayingVM {
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}
