//
//  PrayAddVM.swift
//  Moyang
//
//  Created by kibo on 2021/12/26.
//

import SwiftUI
import Combine

class PrayAddVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var prayRepo: PrayRepo
    
    @Published var praySubject: String = ""
    @Published var prayStartDate: String = ""
    @Published var prayDayList: [String] = []
    @Published var PrayTime: String = ""
    
    init(prayRepo: PrayRepo) {
        self.prayRepo = prayRepo
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func addPray() {
        prayRepo.add(PraySubject(id: "",
                                 subject: praySubject,
                                 timeString: prayStartDate,
                                 prayDayList: prayDayList,
                                 prayTime: PrayTime))
    }
}

