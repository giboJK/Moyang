//
//  MediatorPrayMainVM.swift
//  Moyang
//
//  Created by kibo on 2022/10/24.
//

import RxSwift
import RxCocoa

class MediatorPrayMainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    private let groupList = BehaviorRelay<[String]>(value: [])
    init() {
    }

    deinit { Log.i(self) }
}

extension MediatorPrayMainVM {
    struct Input {

    }

    struct Output {
        let groupList: Driver<[String]>
    }

    func transform(input: Input) -> Output {
        return Output(groupList: groupList.asDriver())
    }
}
