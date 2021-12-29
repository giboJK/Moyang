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
    @Published var prayStartDate: String = Date().toString()
    @Published var prayDayList: [String] = []
    @Published var prayTime: String = "3"
    @Published var alarmTime: Date = Date()
    
    init(prayRepo: PrayRepo) {
        self.prayRepo = prayRepo
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func addPray() {
        Log.w(praySubject)
        Log.w(prayStartDate)
        Log.w(prayDayList)
        Log.w(prayTime)
        Log.w(alarmTime.toString("hh:mm a"))
        prayRepo.add(PraySubject(id: "",
                                 subject: praySubject,
                                 timeString: prayStartDate,
                                 prayDayList: prayDayList,
                                 prayTime: prayTime))
    }
}

enum PrayTime: String, CaseIterable, Identifiable {
    case one = "1분"
    case two = "2분"
    case three = "3분"
    case five = "5분"
    case ten = "10분"
    case twenty = "20분"
    case thirty = "30분"
    case hour = "1시간"
    
    var id: String { self.rawValue }
}

enum PrayDay: String, CaseIterable, Identifiable {
    case sun = "일"
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fri = "금"
    case sat = "토"
    
    var id: String { self.rawValue }
    
    var textColor: Color {
        switch self {
        case .sun:
            return .red
        case .mon, .tue, .wed, .thu, .fri:
            return .black
        case .sat:
            return .blue
        }
    }
    
    var dayCode: String {
        switch self {
        case .sun:
            return "sun"
        case .mon:
            return "mon"
        case .tue:
            return "tue"
        case .wed:
            return "wed"
        case .thu:
            return "thu"
        case .fri:
            return "fri"
        case .sat:
            return "sat"
        }
    }
}
