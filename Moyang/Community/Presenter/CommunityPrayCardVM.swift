//
//  CommunityPrayCardVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/02/16.
//

import SwiftUI
import Combine

class CommunityPrayCardVM: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    
    @Published var item = CommunityPrayCardVM.PrayItem()
    
    init() {
        fetchPrayItem()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func fetchPrayItem() {
        
    }
}

extension CommunityPrayCardVM {
    struct PrayItem {
        let myPray: String
        let lastPrayDate: String
        
        init() {
            myPray = ""
            lastPrayDate = ""
        }
        
        init(myPray: String,
             lastPrayDate: String
        ) {
            self.myPray = myPray
            self.lastPrayDate = lastPrayDate
        }
    }
}
