//
//  IntroVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/11.
//

import RxSwift
import RxCocoa

class IntroVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
    }
}

extension IntroVM {
    struct Input {
        
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
