//
//  PrayListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2021/10/17.
//  Copyright © 2021 정김기보. All rights reserved.
//

import SwiftUI
import Combine

class PrayListVM: ObservableObject {
    @Published var prayList = [PrayListItem]()
    @Published var prayCardVMs: [PrayCardVM] = []
    private var cancellables: Set<AnyCancellable> = []

    private var prayRepo: PrayRepo

    init(prayRepo: PrayRepo) {
        self.prayRepo = prayRepo
        
        prayRepo.$prays.map { prays in
            return prays.map(PrayCardVM.init)
        }
        .assign(to: \.prayCardVMs, on: self)
        .store(in: &cancellables)
    }

    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func add(_ pray: PraySubject) {
        prayRepo.add(pray)
    }
}


extension PrayListVM {
    struct PrayListItem: Identifiable {
        let id: String
        let subject: String
        let timeString: String

        init(praySubject: PraySubject) {
            id = praySubject.id
            subject = praySubject.subject
            timeString = praySubject.timeString
        }
    }
}
