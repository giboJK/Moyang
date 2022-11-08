//
//  MyPrayPrayingVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/08.
//

import RxSwift
import RxCocoa

class MyPrayPrayingVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: MyPrayUseCase

    init(useCase: MyPrayUseCase) {
        self.useCase = useCase
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        
    }
}

extension MyPrayPrayingVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
