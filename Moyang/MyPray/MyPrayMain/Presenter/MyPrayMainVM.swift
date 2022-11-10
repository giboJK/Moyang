//
//  MyPrayMainVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/18.
//

import RxSwift
import RxCocoa

class MyPrayMainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: MyPrayUseCase
    let alarmUseCase: AlarmUseCase
    
    // MARK: - Events
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - UI
    let summary = BehaviorRelay<PraySummary?>(value: nil)
    
    // MARK: - VM
    let detailVM = BehaviorRelay<MyPrayDetailVM?>(value: nil)
    
    init(useCase: MyPrayUseCase, alarmUseCase: AlarmUseCase) {
        self.useCase = useCase
        self.alarmUseCase = alarmUseCase
        bind()
        fetchSumamry()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchSumamry),
                                               name: NSNotification.Name.ReloadPrayMainSummary, object: nil)
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.myPraySummary
            .bind(onNext: { [weak self] data in
                guard let data = data else { return }
                self?.summary.accept(PraySummary(data: data))
            }).disposed(by: disposeBag)
        
        useCase.prayDetail
            .bind(onNext: { [weak self] data in
                guard data != nil else { return }
                self?.createDetailVM()
            }).disposed(by: disposeBag)
    }
    
    @objc func fetchSumamry() {
        if let date = Date().startOfMonth?.toString("yyyy-MM-dd hh:mm:ss Z") {
            useCase.fetchSummary(date: date)
        }
    }
    
    private func fetchPrayDetail() {
        if let prayID = summary.value?.prayID {
            useCase.fetchPrayDetail(prayID: prayID)
        }
    }
    
    private func createDetailVM() {
        detailVM.accept(MyPrayDetailVM(useCase: useCase))
    }
    
    private func toggleAlarm(isOn: Bool) {
        guard let summary = summary.value else { return }
        if let id = summary.alarmID, let time = summary.alarmTime, let day = summary.day {
            alarmUseCase.updateAlarm(alarmID: id, time: time, isOn: isOn, day: day)
        }
    }
}

extension MyPrayMainVM {
    struct Input {
        var selectPray: Driver<Void> = .empty()
        var toggleAlarm: Driver<Bool> = .empty()
    }

    struct Output {
        let isNetworking: Driver<Bool>
        let summary: Driver<PraySummary?>
        let detailVM: Driver<MyPrayDetailVM?>
    }

    func transform(input: Input) -> Output {
        input.selectPray
            .drive(onNext: { [weak self] _ in
                self?.fetchPrayDetail()
            }).disposed(by: disposeBag)
        
        input.toggleAlarm
            .drive(onNext: { [weak self] isOn in
                self?.toggleAlarm(isOn: isOn)
            }).disposed(by: disposeBag)
        
        return Output(isNetworking: isNetworking.asDriver(),
                      summary: summary.asDriver(),
                      detailVM: detailVM.asDriver())
    }
}

extension MyPrayMainVM {
    struct PraySummary {
        // Pray
        let prayID: String?
        let title: String?
        let content: String?
        var latestDate: String?
        let createDate: String?
        
        let countDesc: String?
        
        // PrayAlarm
        let alarmID: String?
        let alarmTime: String?
        let isOn: Bool?
        let day: String?
        
        init(data: MyPraySummary) {
            self.prayID = data.pray?.prayID
            self.title = data.pray?.category
            self.content = data.pray?.content
            self.latestDate = data.pray?.latestDate
            self.createDate = data.pray?.createDate
            
            let monthString = Date().toString("M월엔")
            let countString = " \((data.prayCount ?? 0))개의 기도가 있어요."
            self.countDesc = monthString + countString
            
            self.alarmID = data.alarm?.id
            self.alarmTime = data.alarm?.time
            self.isOn = data.alarm?.isOn
            self.day = data.alarm?.day
        }
    }
}

enum MyPrayOrder: String {
    case latest = "최근순"
    case oldest = "오래된순"
    case isAnswerd = "응답받음"
    case date = "날짜 선택"
    
    var parameter: String {
        switch self {
        case .latest:
            return "latest"
        case .oldest:
            return "oldest"
        case .isAnswerd:
            return "answered"
        case .date:
            return ""
        }
    }
}
