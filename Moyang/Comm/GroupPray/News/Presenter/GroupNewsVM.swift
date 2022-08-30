//
//  GroupNewsVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/30.
//

import RxSwift
import RxCocoa

class GroupNewsVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let groupUseCase: GroupUseCase
    let prayUseCase: PrayUseCase

    init(groupUseCase: GroupUseCase, prayUseCase: PrayUseCase) {
        self.groupUseCase = groupUseCase
        self.prayUseCase = prayUseCase
    }

    deinit { Log.i(self) }
}

extension GroupNewsVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
