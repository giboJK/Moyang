//
//  CommunityGroupCardVMMock.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import Combine

class CommunityGroupCardVMMock: CommunityGroupCardVM {
    private var disposables = Set<AnyCancellable>()
    
    override init() {
        super.init()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    override func fetchGroupItem() {
        
    }
}
