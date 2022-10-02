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
    
    private let newAlarmTitle = BehaviorRelay<String>(value: "")
    private let prayTime = BehaviorRelay<AlarmItem?>(value: nil)
    private let qtTime = BehaviorRelay<AlarmItem?>(value: nil)

    init(useCase: AlarmUseCase) {
        self.useCase = useCase
        bind()
        fetchAlarms()
    }

    deinit { Log.i(self) }
    
    func setType(type: AlarmType) {
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
                    
                }
                
                if let qt = list.first(where: { $0.type == AlarmType.qt.rawValue.uppercased() }) {
                    
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchAlarms() {
        useCase.fetchAlarms()
    }
}

extension AlarmSetVM {
    struct Input {
        var setNewPray: Driver<Void> = .empty()
        var setNewQT: Driver<Void> = .empty()
        var save: Driver<Void> = .empty()
    }

    struct Output {
        let prayTime: Driver<AlarmItem?>
        let qtTime: Driver<AlarmItem?>
        let newAlarmTitle: Driver<String>
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
        
        return Output(prayTime: prayTime.asDriver(),
                      qtTime: qtTime.asDriver(),
                      newAlarmTitle: newAlarmTitle.asDriver()
        )
    }
    
    struct AlarmItem {
        let time: String
        let desc: String
        let isOn: Bool
        let isEmpty: Bool
        
        init(time: String, desc: String, isOn: Bool, isEmpty: Bool) {
            self.time = time
            self.desc = desc
            self.isOn = isOn
            self.isEmpty = isEmpty
        }
    }
}
