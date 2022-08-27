//
//  SplashVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/27.
//

import RxSwift
import RxCocoa

class SplashVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: AuthUseCase
        
    let first = ["하나님"]
    let second = ["저는", "오늘도", "영원히", "제 삶을"]
    let third = ["예배자입니다", "감사합니다", "사랑합니다", "드립니다"]
    
    let firstStr = BehaviorRelay<String>(value: "")
    let secondStr = BehaviorRelay<String>(value: "")
    let thirdStr = BehaviorRelay<String>(value: "")
    
    let isLoginSuccess = BehaviorRelay<Void>(value: ())
    let isLoginFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: AuthUseCase) {
        self.useCase = useCase
        let randomInt = Int.random(in: 0..<4)
        firstStr.accept(first[0])
        secondStr.accept(second[randomInt])
        thirdStr.accept(third[randomInt])
        bind()
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
    
    func autoLogin() {
        if let email = UserData.shared.email, let pw = UserData.shared.password {
            useCase.appLogin(email: email, credential: pw)
        } else {
            isLoginFailure.accept(())
        }
    }
}

extension SplashVM {
    struct Input {

    }

    struct Output {
        let first: Driver<String>
        let second: Driver<String>
        let third: Driver<String>
        
        let isLoginSuccess: Driver<Void>
        let isLoginFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        return Output(
            first: firstStr.asDriver(),
            second: secondStr.asDriver(),
            third: thirdStr.asDriver(),
            
            isLoginSuccess: isLoginSuccess.asDriver(),
            isLoginFailure: isLoginFailure.asDriver()
        )
    }
}
