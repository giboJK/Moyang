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
    
    private let prayTimeList = BehaviorRelay<[AlarmItem]>(value: [])
    private let qtTimeList = BehaviorRelay<[AlarmItem]>(value: [])

    init(useCase: AlarmUseCase) {
        self.useCase = useCase
    }

    deinit { Log.i(self) }
}

extension AlarmSetVM {
    struct Input {

    }

    struct Output {
        let prayTimeList: Driver<[AlarmItem]>
        let qtTimeList: Driver<[AlarmItem]>
    }

    func transform(input: Input) -> Output {
        return Output(prayTimeList: prayTimeList.asDriver(),
                      qtTimeList: qtTimeList.asDriver()
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
