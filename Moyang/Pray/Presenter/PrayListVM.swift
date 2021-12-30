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
    private var cancellables: Set<AnyCancellable> = []
    private var prayRepo: PrayRepo
    
    @Published var prayList = [PrayListItem]()
    @Published var prayCardVMs: [PrayCardVM] = []

    init(prayRepo: PrayRepo) {
        self.prayRepo = prayRepo
    }

    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func fetchPrayList() {
        prayRepo.addPraySubjectListListener()
            .map { praySubjectList -> [PrayCardVM] in
                var list = [PrayCardVM]()
                praySubjectList.forEach { praySubject in
                    list.append(PrayCardVM.init(pray: praySubject))
                }
                return list
            }
            .sink { completion in
                Log.i(completion)
            } receiveValue: { item in
                self.prayCardVMs = item
                Log.w(self.prayCardVMs)
            }.store(in: &cancellables)
    }
}

extension PrayListVM {
    struct PrayListItem: Identifiable {
        let id: String
        let subject: String
        let alarmTime: String
        let prayTime: String

        init(praySubject: PraySubject) {
            id = praySubject.id
            subject = praySubject.praySubject
            alarmTime = praySubject.prayAlarmTime
            prayTime = praySubject.prayTime
        }
    }
}
