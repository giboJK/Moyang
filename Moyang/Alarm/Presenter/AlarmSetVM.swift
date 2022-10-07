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
    private let setupNewAlarm = BehaviorRelay<Void>(value: ())
    private let editAlarm = BehaviorRelay<Void>(value: ())
    private let isEditing = BehaviorRelay<Bool>(value: false)
    
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
    
    var alarmTime = Date().toString("HH:mm")
    var alarmType = AlarmType.pray
    

    init(useCase: AlarmUseCase) {
        self.useCase = useCase
        bind()
        fetchAlarms()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.alarms
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                if let pray = list.first(where: { $0.type == AlarmType.pray.rawValue.uppercased() }) {
                    self.prayTime.accept(AlarmItem(id: pray.id, time: pray.time, isOn: pray.isOn, day: pray.day))
                } else {
                    self.prayTime.accept(nil)
                }
                
                if let qt = list.first(where: { $0.type == AlarmType.qt.rawValue.uppercased() }) {
                    self.qtTime.accept(AlarmItem(id: qt.id, time: qt.time, isOn: qt.isOn, day: qt.day))
                } else {
                    self.qtTime.accept(nil)
                }
            }).disposed(by: disposeBag)
        
        useCase.isSuccess
            .skip(1)
            .bind(to: addingSuccess)
            .disposed(by: disposeBag)
        
        useCase.isFailure
            .skip(1)
            .bind(to: addingFailure)
            .disposed(by: disposeBag)
        
    }
    
    private func fetchAlarms() {
        useCase.fetchAlarms()
    }
    
    private func saveAlarm() {
        var day = ""
        day += isSun.value ? "0" : ""
        day += isMon.value ? "1" : ""
        day += isTue.value ? "2" : ""
        day += isWed.value ? "3" : ""
        day += isThu.value ? "4" : ""
        day += isFri.value ? "5" : ""
        day += isSat.value ? "6" : ""
        
        useCase.addAlarm(time: alarmTime, isOn: true, type: alarmType, day: day)
    }
    private func updateAlarm() {
        var day = ""
        day += isSun.value ? "0" : ""
        day += isMon.value ? "1" : ""
        day += isTue.value ? "2" : ""
        day += isWed.value ? "3" : ""
        day += isThu.value ? "4" : ""
        day += isFri.value ? "5" : ""
        day += isSat.value ? "6" : ""
        var id = ""
        if alarmType == .pray {
            id = prayTime.value?.id ?? ""
        } else {
            id = qtTime.value?.id ?? ""
        }
        useCase.updateAlarm(alarmID: id, time: alarmTime, isOn: true, day: day)
    }
    
    private func deleteAlarm() {
        var id = ""
        if alarmType == .pray {
            id = prayTime.value?.id ?? ""
        } else {
            id = qtTime.value?.id ?? ""
        }
        useCase.deleteAlarm(alarmID: id)
    }
    
    private func setNewAlarm(type: AlarmType) {
        if type == .pray {
            newAlarmTitle.accept("기도알람 추가")
        } else {
            newAlarmTitle.accept("묵상알람 추가")
        }
        isEditing.accept(false)
        alarmType = type
        setupNewAlarm.accept(())
    }
    
    private func editAlarm(type: AlarmType) {
        if type == .pray {
            newAlarmTitle.accept("기도알람 편집")
            if let pray = prayTime.value {
                isSun.accept(pray.isSun)
                isMon.accept(pray.isMon)
                isTue.accept(pray.isTue)
                isWed.accept(pray.isWed)
                isThu.accept(pray.isThu)
                isFri.accept(pray.isFri)
                isSat.accept(pray.isSat)
            }
        } else {
            newAlarmTitle.accept("묵상알람 편집")
            if let qt = qtTime.value {
                isSun.accept(qt.isSun)
                isMon.accept(qt.isMon)
                isTue.accept(qt.isTue)
                isWed.accept(qt.isWed)
                isThu.accept(qt.isThu)
                isFri.accept(qt.isFri)
                isSat.accept(qt.isSat)
            }
        }
        alarmType = type
        isEditing.accept(true)
        editAlarm.accept(())
    }
    
    private func resetEditing() {
        isEditing.accept(false)
        isSun.accept(false)
        isMon.accept(false)
        isTue.accept(false)
        isWed.accept(false)
        isThu.accept(false)
        isFri.accept(false)
        isSat.accept(false)
    }
    
    private func togglePrayAlarm(isOn: Bool) {
        guard let alarm = prayTime.value else { return }
        let id = alarm.id
        var day = ""
        day += alarm.isSun ? "0" : ""
        day += alarm.isMon ? "1" : ""
        day += alarm.isTue ? "2" : ""
        day += alarm.isWed ? "3" : ""
        day += alarm.isThu ? "4" : ""
        day += alarm.isFri ? "5" : ""
        day += alarm.isSat ? "6" : ""
        
        useCase.updateAlarm(alarmID: id, time: alarm.time, isOn: isOn, day: day)
    }
    
    private func toggleQtAlarm(isOn: Bool) {
        guard let alarm = qtTime.value else { return }
        let id = alarm.id
        var day = ""
        day += alarm.isSun ? "0" : ""
        day += alarm.isMon ? "1" : ""
        day += alarm.isTue ? "2" : ""
        day += alarm.isWed ? "3" : ""
        day += alarm.isThu ? "4" : ""
        day += alarm.isFri ? "5" : ""
        day += alarm.isSat ? "6" : ""
        
        useCase.updateAlarm(alarmID: id, time: alarm.time, isOn: isOn, day: day)
    }
}

extension AlarmSetVM {
    struct Input {
        var setNewPray: Driver<Void> = .empty()
        var setNewQT: Driver<Void> = .empty()
        var editPray: Driver<Void> = .empty()
        var editQT: Driver<Void> = .empty()
        
        var togglePrayAlarm: Driver<Bool> = .empty()
        var toggleQtAlarm: Driver<Bool> = .empty()

        var save: Driver<Void> = .empty()
        var delete: Driver<Void> = .empty()
        var setTime: Driver<Date> = .empty()
        var toggleSun: Driver<Void> = .empty()
        var toggleMon: Driver<Void> = .empty()
        var toggleTue: Driver<Void> = .empty()
        var toggleWed: Driver<Void> = .empty()
        var toggleThu: Driver<Void> = .empty()
        var toggleFri: Driver<Void> = .empty()
        var toggleSat: Driver<Void> = .empty()
        var resetEditing: Driver<Void> = .empty()
    }

    struct Output {
        let prayTime: Driver<AlarmItem?>
        let qtTime: Driver<AlarmItem?>
        
        let setupNewAlarm: Driver<Void>
        let editAlarm: Driver<Void>
        let isEditing: Driver<Bool>
        
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
                self?.setNewAlarm(type: .pray)
            }).disposed(by: disposeBag)
        
        input.setNewQT
            .drive(onNext: { [weak self] _ in
                self?.setNewAlarm(type: .qt)
            }).disposed(by: disposeBag)
        
        input.editPray
            .drive(onNext: { [weak self] _ in
                self?.editAlarm(type: .pray)
            }).disposed(by: disposeBag)
        
        input.editQT
            .drive(onNext: { [weak self] _ in
                self?.editAlarm(type: .qt)
            }).disposed(by: disposeBag)
        
        input.save
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.isEditing.value {
                    self.updateAlarm()
                } else {
                    self.saveAlarm()
                }
            }).disposed(by: disposeBag)
        
        input.delete
            .drive(onNext: { [weak self] _ in
                self?.deleteAlarm()
            }).disposed(by: disposeBag)
        
        input.togglePrayAlarm
            .skip(1)
            .drive(onNext: { [weak self] isOn in
                self?.togglePrayAlarm(isOn: isOn)
            }).disposed(by: disposeBag)
        
        input.toggleQtAlarm
            .skip(1)
            .drive(onNext: { [weak self] isOn in
                self?.toggleQtAlarm(isOn: isOn)
            }).disposed(by: disposeBag)
        
        input.setTime
            .drive(onNext: { [weak self] date in
                self?.alarmTime = date.toString("HH:mm")
            }).disposed(by: disposeBag)
        
        input.toggleSun
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                self.isSun.accept(!self.isSun.value)
            }).disposed(by: disposeBag)
        
        input.toggleMon
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                self.isMon.accept(!self.isMon.value)
            }).disposed(by: disposeBag)
        
        input.toggleTue
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                self.isTue.accept(!self.isTue.value)
            }).disposed(by: disposeBag)
    
        input.toggleWed
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                self.isWed.accept(!self.isWed.value)
            }).disposed(by: disposeBag)
        
        input.toggleThu
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                self.isThu.accept(!self.isThu.value)
            }).disposed(by: disposeBag)
        
        input.toggleFri
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                self.isFri.accept(!self.isFri.value)
            }).disposed(by: disposeBag)
        
        input.toggleSat
            .drive(onNext: { [weak self] _  in
                guard let self = self else { return }
                self.isSat.accept(!self.isSat.value)
            }).disposed(by: disposeBag)
        
        input.resetEditing
            .drive(onNext: { [weak self] _ in
                self?.resetEditing()
            }).disposed(by: disposeBag)
        
        return Output(prayTime: prayTime.asDriver(),
                      qtTime: qtTime.asDriver(),
                      setupNewAlarm: setupNewAlarm.asDriver(),
                      editAlarm: editAlarm.asDriver(),
                      isEditing: isEditing.asDriver(),
                      
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
        let id: String
        let time: String
        let isOn: Bool
        let isSun: Bool
        let isMon: Bool
        let isTue: Bool
        let isWed: Bool
        let isThu: Bool
        let isFri: Bool
        let isSat: Bool
        
        init(id: String, time: String, isOn: Bool, day: String) {
            self.id = id
            self.time = time
            self.isOn = isOn
            self.isSun = day.contains("0")
            self.isMon = day.contains("1")
            self.isTue = day.contains("2")
            self.isWed = day.contains("3")
            self.isThu = day.contains("4")
            self.isFri = day.contains("5")
            self.isSat = day.contains("6")
        }
    }
}
