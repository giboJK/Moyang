//
//  TodayVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/10.
//

import RxSwift
import RxCocoa

class TodayVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension TodayVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
