//
//  AlarmSetVM.swift
//  Moyang
//
//  Created by kibo on 2022/09/14.
//

import RxSwift
import RxCocoa

class AlarmSetVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    
    let useCase: AlarmUseCase
    
    private let prayTime = BehaviorRelay<AlarmItem?>(value: nil)
    private let qtTime = BehaviorRelay<AlarmItem?>(value: nil)
    
    // NewAlarm
    private let newAlarmTitle = BehaviorRelay<String>(value: "")
    private let isSun = BehaviorRelay<Bool>(value: false)
    private let isMon = BehaviorRelay<Bool>(value: false)
    private let isTue = BehaviorRelay<Bool>(value: false)
    private let isWed = BehaviorRelay<Bool>(value: false)
    private let isThu = BehaviorRelay<Bool>(value: false)
    private let isFri = BehaviorRelay<Bool>(value: false)
    private let isSat = BehaviorRelay<Bool>(value: false)
    
    private let addingSuccess = BehaviorRelay<Void>(value: ())
    private let addingFailure = BehaviorRelay<Void>(value: ())
    
    var newAlarmTime = Date().toString("HH:mm")
    var newAlarmType = AlarmType.pray
    

    init(useCase: AlarmUseCase) {
        self.useCase = useCase
        bind()
        fetchAlarms()
    }

    deinit { Log.i(self) }
    
    func setType(type: AlarmType) {
        newAlarmType = type
        switch type {
        case .pray:
            newAlarmTitle.accept("새 기도알람")
        case .qt:
            newAlarmTitle.accept("새 묵상알람")
        default:
            break
        }
    }
    
    private func bind() {
        useCase.alarms
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                if let pray = list.first(where: { $0.type == AlarmType.pray.rawValue.uppercased() }) {
                    self.prayTime.accept(AlarmItem(time: pray.time, isOn: pray.isOn))
                }
                
                if let qt = list.first(where: { $0.type == AlarmType.qt.rawValue.uppercased() }) {
                    self.qtTime.accept(AlarmItem(time: qt.time, isOn: qt.isOn))
                }
            }).disposed(by: disposeBag)
        
        useCase.addingSuccess
            .skip(1)
            .bind(to: addingSuccess)
            .disposed(by: disposeBag)
        
        useCase.addingFailure
            .skip(1)
            .bind(to: addingFailure)
            .disposed(by: disposeBag)
        
    }
    
    private func fetchAlarms() {
        useCase.fetchAlarms()
    }
    
    private func saveAlarm() {
        useCase.addAlarm(time: newAlarmTime, isOn: true, type: newAlarmType)
    }
}

extension AlarmSetVM {
    struct Input {
        var setNewPray: Driver<Void> = .empty()
        var setNewQT: Driver<Void> = .empty()
        var save: Driver<Void> = .empty()
        var setTime: Driver<Date> = .empty()
        var toggleSun: Driver<Void> = .empty()
        var toggleMon: Driver<Void> = .empty()
        var toggleTue: Driver<Void> = .empty()
        var toggleWed: Driver<Void> = .empty()
        var toggleThu: Driver<Void> = .empty()
        var toggleFri: Driver<Void> = .empty()
        var toggleSat: Driver<Void> = .empty()
    }

    struct Output {
        let prayTime: Driver<AlarmItem?>
        let qtTime: Driver<AlarmItem?>
        
        let newAlarmTitle: Driver<String>
        let isSun: Driver<Bool>
        let isMon: Driver<Bool>
        let isTue: Driver<Bool>
        let isWed: Driver<Bool>
        let isThu: Driver<Bool>
        let isFri: Driver<Bool>
        let isSat: Driver<Bool>
        
        let addingSuccess: Driver<Void>
        let addingFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.setNewPray
            .drive(onNext: { [weak self] _ in
                self?.setType(type: .pray)
            }).disposed(by: disposeBag)
        
        input.setNewQT
            .drive(onNext: { [weak self] _ in
                self?.setType(type: .qt)
            }).disposed(by: disposeBag)
        
        input.save
            .drive(onNext: { [weak self] _ in
                self?.saveAlarm()
            }).disposed(by: disposeBag)
        
        input.setTime
            .drive(onNext: { [weak self] date in
                self?.newAlarmTime = date.toString("HH:mm")
            }).disposed(by: disposeBag)
        
        input.toggleSun
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                var isChecked = self.isSun.value
                isChecked.toggle()
                self.isSun.accept(isChecked)
            }).disposed(by: disposeBag)
        
        input.toggleMon
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                var isChecked = self.isMon.value
                isChecked.toggle()
                self.isMon.accept(isChecked)
            }).disposed(by: disposeBag)
        
        input.toggleTue
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                var isChecked = self.isTue.value
                isChecked.toggle()
                self.isTue.accept(isChecked)
            }).disposed(by: disposeBag)
    
        input.toggleWed
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                var isChecked = self.isWed.value
                isChecked.toggle()
                self.isWed.accept(isChecked)
            }).disposed(by: disposeBag)
        
        input.toggleThu
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                var isChecked = self.isThu.value
                isChecked.toggle()
                self.isThu.accept(isChecked)
            }).disposed(by: disposeBag)
        
        input.toggleFri
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                var isChecked = self.isFri.value
                isChecked.toggle()
                self.isFri.accept(isChecked)
            }).disposed(by: disposeBag)
        
        input.toggleSat
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                var isChecked = self.isSat.value
                isChecked.toggle()
                self.isSat.accept(isChecked)
            }).disposed(by: disposeBag)
        
        return Output(prayTime: prayTime.asDriver(),
                      qtTime: qtTime.asDriver(),
                      
                      newAlarmTitle: newAlarmTitle.asDriver(),
                      isSun: isSun.asDriver(),
                      isMon: isMon.asDriver(),
                      isTue: isTue.asDriver(),
                      isWed: isWed.asDriver(),
                      isThu: isThu.asDriver(),
                      isFri: isFri.asDriver(),
                      isSat: isSat.asDriver(),
                      
                      addingSuccess: addingSuccess.asDriver(),
                      addingFailure: addingFailure.asDriver()
        )
    }
    
    struct AlarmItem {
        let time: String
        let isOn: Bool
        
        init(time: String, isOn: Bool) {
            self.time = time
            self.isOn = isOn
        }
    }
}
