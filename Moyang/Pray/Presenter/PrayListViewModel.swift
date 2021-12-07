//
//  PrayListViewModel.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/17.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class PrayListViewModel: ObservableObject {
    @Published var prayList = [PrayListItem]()
    
    private var disposables = Set<AnyCancellable>()

    private var prayRepo: PrayRepo

    init(prayRepo: PrayRepo) {
        self.prayRepo = prayRepo
        
    }

    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func fetchPraySubject() {
    }
}


extension PrayListViewModel {
    struct PrayListItem: Identifiable {
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
