//
//  MyPrayMainVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/18.
//

import RxSwift
import RxCocoa

class MyPrayMainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension MyPrayMainVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
