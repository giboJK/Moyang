//
//  GroupPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import RxSwift
import RxCocoa

class GroupPrayVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension GroupPrayVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
