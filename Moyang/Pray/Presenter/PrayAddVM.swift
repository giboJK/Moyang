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
    
    @State var praySubject: String = ""
    @State var prayStartDate: String = ""
    @State var prayDayList: String = ""
    @State var PrayTime: String = ""
    
    init() {
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
}

