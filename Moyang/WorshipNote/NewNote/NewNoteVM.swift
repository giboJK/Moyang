//
//  NewNoteVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import RxSwift
import RxCocoa

class NewNoteVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension NewNoteVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
