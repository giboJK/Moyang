//
//  NoticeVM.swift
//  Moyang
//
//  Created by kibo on 2022/10/05.
//

import RxSwift
import RxCocoa

class NoticeVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension NoticeVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
