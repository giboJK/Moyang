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
    let useCase: MyPrayUseCase

    init(useCase: MyPrayUseCase) {
        self.useCase = useCase
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
    }
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
