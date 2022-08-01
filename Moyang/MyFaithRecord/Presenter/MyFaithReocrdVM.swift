//
//  MyFaithReocrdVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/01.
//

import RxSwift
import RxCocoa

class MyFaithReocrdVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension MyFaithReocrdVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
