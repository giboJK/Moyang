//
//  MyPrayListVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//

import RxSwift
import RxCocoa

class MyPrayListVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension MyPrayListVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
