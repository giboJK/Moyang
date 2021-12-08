//
//  PrayPreviewVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/11.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class PrayPreviewVM: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    
    private var prayRepo: PrayRepo
    
    init(prayRepo: PrayRepo) {
        self.prayRepo = prayRepo
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
}

extension PrayPreviewVM {
    enum State {
        case idle
        case loading
        case loaded(PrayPreviewVM.PrayPreviewItem)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onItemLoaded(PrayPreviewVM.PrayPreviewItem)
        case onFailedToLoadPray(Error)
    }
}

extension PrayPreviewVM {
    struct PrayPreviewItem: Identifiable {
        let id: Int
        let subject: String
        let timeString: String
        
        init(praySubject: PraySubject) {
            id = praySubject.id
            subject = praySubject.subject
            timeString = praySubject.timeString
        }
    }
}
