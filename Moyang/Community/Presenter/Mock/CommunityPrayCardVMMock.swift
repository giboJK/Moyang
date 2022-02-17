//
//  CommunityPrayCardVMMock.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/16.
//

import SwiftUI
import Combine

class CommunityPrayCardVMMock: CommunityPrayCardVM {
    private var disposables = Set<AnyCancellable>()
    
    override init() {
        super.init()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    override func fetchPrayItem() {
        item = CommunityPrayCardVM.PrayItem(myPray: "신실하신 하나님. 주님의 뜻은 저보다 높고 깊으심을. 주님의 약속이 언제나 반드시 이루어질 것임을. 소망을 품고 하루를 살게 해주세요",
                                            lastPrayDate: "2022.02.16")
    }
}
