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
    @Published var prayTime: String = PrayTime.one.rawValue
    @Published var alarmTime: Date = Date()
    @Published var showingAlert = false
    @Published var isAlarmOn = false
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }

    func prayIsAdded() {
        self.shouldDismissView = true
    }
    
    var alertTitle = ""
    
    init(prayRepo: PrayRepo) {
        self.prayRepo = prayRepo
    }
    
    init(prayRepo: PrayRepo, pray: Pray) {
        self.prayRepo = prayRepo
        self.praySubject = pray.praySubject
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    func addPray() {
        if praySubject.isEmpty {
            showingAlert = true
            alertTitle = "기도 제목을 입력하세요"
            return
        }
        
        if isAlarmOn && prayDayList.isEmpty {
            showingAlert = true
            alertTitle = "요일을 선택하세요"
            return
        }
        
        let prayTimeCode = PrayTime(rawValue: prayTime)!
        prayRepo.add(Pray(id: Date().toString("yyyy-MM-dd hh:mm:ss a"),
                          type: PrayType.my.rawValue,
                          createdTimestamp: Date().toString("yyyy-MM-dd hh:mm:ss a"),
                          praySubject: praySubject,
                          isAlarmOn: isAlarmOn,
                          prayAlarmTime: alarmTime.toString("hh:mm a"),
                          prayDayList: prayDayList,
                          prayTime: prayTimeCode.code))
            .sink(receiveCompletion: { Log.i($0) },
                  receiveValue: { [weak self] isSaved in
                if isSaved {
                    self?.prayIsAdded()
                } else {
                    self?.showingAlert = true
                    self?.alertTitle = "네트워크 오류"
                }
            }).store(in: &cancellables)
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
    case noChoice = "선택안함"
    
    var id: String { self.rawValue }
    
    var code: String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .five:
            return "5"
        case .ten:
            return "10"
        case .twenty:
            return "20"
        case .thirty:
            return "30"
        case .hour:
            return "60"
        case .noChoice:
            return "-1"
        }
    }
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
