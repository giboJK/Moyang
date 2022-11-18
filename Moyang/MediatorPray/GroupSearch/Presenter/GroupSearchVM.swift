//
//  GroupSearchVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/18.
//

import RxSwift
import RxCocoa

class GroupSearchVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: GroupUseCase

    init(useCase: GroupUseCase) {
        self.useCase = useCase
        bind()
    }

    deinit { Log.i(self) }

    private func bind() {

    }
}

extension GroupSearchVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
