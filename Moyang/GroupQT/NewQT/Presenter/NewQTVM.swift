//
//  NewQTVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/11.
//

import RxSwift
import RxCocoa

class NewQTVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension NewQTVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
