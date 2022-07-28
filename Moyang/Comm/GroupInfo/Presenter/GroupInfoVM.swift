//
//  GroupInfoVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/10.
//

import RxSwift
import RxCocoa

class GroupInfoVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    
    let pastorInCharge = BehaviorRelay<String>(value: "")
    let groupStartDate = BehaviorRelay<String>(value: "")
    let memberList = BehaviorRelay<[String]>(value: [])

    init() {
    }

    deinit { Log.i(self) }
}

extension GroupInfoVM {
    struct Input {

    }

    struct Output {
        let pastorInCharge: Driver<String>
        let groupStartDate: Driver<String>
        let memberList: Driver<[String]>
    }

    func transform(input: Input) -> Output {
        return Output(pastorInCharge: pastorInCharge.asDriver(),
                      groupStartDate: groupStartDate.asDriver(),
                      memberList: memberList.asDriver()
        )
    }
}
