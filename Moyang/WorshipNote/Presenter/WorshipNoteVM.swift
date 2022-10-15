//
//  WorshipNoteVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/15.
//

import RxSwift
import RxCocoa

class WorshipNoteVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    var useCase: WorshipNoteUseCase
    
    init(useCase: WorshipNoteUseCase) {
        self.useCase = useCase
    }

    deinit { Log.i(self) }
}

extension WorshipNoteVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
