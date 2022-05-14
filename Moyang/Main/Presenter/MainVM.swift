//
//  MainVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/14.
//

import RxSwift
import RxCocoa

class MainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension MainVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
