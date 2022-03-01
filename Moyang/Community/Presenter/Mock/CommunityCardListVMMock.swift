//
//  CommunityCardListVMMock.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import SwiftUI
import Combine

class CommunityCardListVMMock: CommunityCardListVM {
    
    init() {
        super.init(repo: CommunityListService())
    }
    
    override func fetchCommunityData() {
        communityGroupCardVM = CommunityGroupCardVMMock()
    }
}
