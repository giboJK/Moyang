//
//  TaskDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/12.
//

import RxSwift
import RxCocoa

class TaskDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension TaskDetailVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
