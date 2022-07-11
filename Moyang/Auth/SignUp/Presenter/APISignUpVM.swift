//
//  APISignUpVM.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import RxSwift
import RxCocoa

class APISignUpVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: SignUpUseCase

    init(useCase: SignUpUseCase) {
        self.useCase = useCase
    }

    deinit { Log.i(self) }
}

extension APISignUpVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
