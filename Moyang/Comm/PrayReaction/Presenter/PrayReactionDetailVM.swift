//
//  PrayReactionDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/07/01.
//

import RxSwift
import RxCocoa

class PrayReactionDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension PrayReactionDetailVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
