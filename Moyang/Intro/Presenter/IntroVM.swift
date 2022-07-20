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
    let useCase: AuthUseCase
    
    let isLoginSuccess = BehaviorRelay<Void>(value: ())
    let isLoginFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: AuthUseCase) {
        self.useCase = useCase
        bind()
        autoLogin()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        useCase.isLoginSuccess
            .skip(1)
            .bind(to: isLoginSuccess)
            .disposed(by: disposeBag)
        
        useCase.isLoginFailure
            .skip(1)
            .bind(to: isLoginFailure)
            .disposed(by: disposeBag)
    }
    
    private func autoLogin() {
        if let email = UserData.shared.email, let pw = UserData.shared.password {
            useCase.appLogin(email: email, credential: pw)
        }
    }
}

extension IntroVM {
    struct Input {
        
    }
    
    struct Output {
        let isLoginSuccess: Driver<Void>
        let isLoginFailure: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(isLoginSuccess: isLoginSuccess.asDriver(),
                      isLoginFailure: isLoginFailure.asDriver()
        )
    }
}
