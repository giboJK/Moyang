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

    init() {
    }

    deinit { Log.i(self) }
}

extension AlarmSetVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
