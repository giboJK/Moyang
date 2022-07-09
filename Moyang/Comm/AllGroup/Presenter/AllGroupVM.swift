//
//  AllGroupVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import RxSwift
import RxCocoa

class AllGroupVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: AllGroupUseCase

    init(useCase: AllGroupUseCase) {
        self.useCase = useCase
    }

    deinit { Log.i(self) }
}

extension AllGroupVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}

extension AllGroupVM {
    struct GroupItem {
        
    }
}
