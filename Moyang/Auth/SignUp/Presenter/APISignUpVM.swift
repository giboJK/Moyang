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
    
    let isAlreadyExist = BehaviorRelay<Void>(value: ())

    init(useCase: SignUpUseCase) {
        self.useCase = useCase
    }

    deinit { Log.i(self) }
}

extension APISignUpVM {
    struct Input {
        let checkExist: Driver<Void>
    }

    struct Output {
        let isAlreadyExist: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.checkExist
            .drive(onNext: { [weak self] _ in
                self?.useCase.registUser(id: "uuukkisd", pw: "asdasd", name: "lasmlsd")
            }).disposed(by: disposeBag)
        
        return Output(isAlreadyExist: isAlreadyExist.asDriver())
    }
}
