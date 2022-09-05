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
    let second = ["약속을", "말씀은", "영원히", "저는"]
    let third = ["이루십니다", "살아있습니다", "사랑합니다", "예배자입니다"]
    
    let firstStr = BehaviorRelay<String>(value: "")
    let secondStr = BehaviorRelay<String>(value: "")
    let thirdStr = BehaviorRelay<String>(value: "")
    
    let isLoginSuccess = BehaviorRelay<Void>(value: ())
    let isLoginFailure = BehaviorRelay<Void>(value: ())
    
    let isRequired = BehaviorRelay<Bool>(value: false)
    let isRecommended = BehaviorRelay<Bool>(value: false)
    let isLatestVersion = BehaviorRelay<Bool>(value: false)
    let hasLatestToken = BehaviorRelay<Bool>(value: false)
    
    var hasTryAutoLogin = false
    
    init(useCase: AuthUseCase) {
        self.useCase = useCase
        let randomInt = Int.random(in: 0..<4)
        firstStr.accept(first[0])
        secondStr.accept(second[randomInt])
        thirdStr.accept(third[randomInt])
        useCase.checkAppVersion()
        bind()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTokenSuccess),
                                               name: NSNotification.Name("UPDATE_TOKEN_SUCCESS"), object: nil)
        // Token이 안 날라올 경우 3초뒤에 autoLogin시도
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.moveToIntro()
        }
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.versionInfo
            .subscribe(onNext: { [weak self] info in
                guard let info = info else { return }
                if info.status == "Required" {
                    self?.isRequired.accept(true)
                } else if info.status == "Recommended" {
                    self?.isRecommended.accept(true)
                } else {
                    self?.isLatestVersion.accept(true)
                }
            }).disposed(by: disposeBag)
        
        useCase.isLoginSuccess
            .skip(1)
            .bind(to: isLoginSuccess)
            .disposed(by: disposeBag)
        
        useCase.isLoginFailure
            .skip(1)
            .bind(to: isLoginFailure)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(isLatestVersion, hasLatestToken)
            .subscribe(onNext: { [weak self] (isLatestVersion, hasLatestToken) in
                if isLatestVersion && hasLatestToken {
                    self?.autoLogin()
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func updateTokenSuccess() {
        hasLatestToken.accept(true)
    }
    
    @objc func autoLogin() {
        hasTryAutoLogin = true
        if let email = UserData.shared.email, let pw = UserData.shared.password {
            useCase.appLogin(email: email, credential: pw)
        } else {
            isLoginFailure.accept(())
        }
    }
    
    private func moveToIntro() {
        if isRequired.value {
            Log.d("Update is required")
            return
        }
        if isRecommended.value {
            Log.d("Update is recommended")
            return
        }
        if hasTryAutoLogin {
            return
        }
        isLoginFailure.accept(())
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
        
        let isRequired: Driver<Bool>
        let isRecommended: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        return Output(
            first: firstStr.asDriver(),
            second: secondStr.asDriver(),
            third: thirdStr.asDriver(),
            
            isLoginSuccess: isLoginSuccess.asDriver(),
            isLoginFailure: isLoginFailure.asDriver(),
            
            isRequired: isRequired.asDriver(),
            isRecommended: isRecommended.asDriver()
        )
    }
}
