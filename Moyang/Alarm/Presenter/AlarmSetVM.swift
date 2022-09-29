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
    
    private let prayTimeList = BehaviorRelay<[String]>(value: [])
    private let qtTimeList = BehaviorRelay<[String]>(value: [])

    init() {
    }

    deinit { Log.i(self) }
}

extension AlarmSetVM {
    struct Input {

    }

    struct Output {
        let prayTimeList: Driver<[String]>
        let qtTimeList: Driver<[String]>
    }

    func transform(input: Input) -> Output {
        return Output(prayTimeList: prayTimeList.asDriver(),
                      qtTimeList: qtTimeList.asDriver()
        )
    }
}
