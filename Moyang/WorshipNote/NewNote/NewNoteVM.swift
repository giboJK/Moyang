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
    
    var useCase: WorshipNoteUseCase
    var bibleUseCasa: BibleUseCase
    
    let bibleSelectVM = BehaviorRelay<BibleSelectVM?>(value: nil)
    
    init(useCase: WorshipNoteUseCase, bibleUseCasa: BibleUseCase) {
        self.useCase = useCase
        self.bibleUseCasa = bibleUseCasa
    }

    deinit { Log.i(self) }
}

extension NewNoteVM {
    struct Input {
        var selectBible: Driver<Void>
    }

    struct Output {
        let bibleSelectVM: Driver<BibleSelectVM?>
    }

    func transform(input: Input) -> Output {
        input.selectBible.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.bibleSelectVM.accept(BibleSelectVM(useCase: self.bibleUseCasa))
        }).disposed(by: disposeBag)
        
        return Output(bibleSelectVM: bibleSelectVM.asDriver())
    }
}
