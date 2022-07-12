//
//  SignUpVM.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import RxSwift
import RxCocoa

class SignUpVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: SignUpUseCase
    
    let email = BehaviorRelay<String?>(value: nil)
    let password = BehaviorRelay<String?>(value: nil)
    
    let name = BehaviorRelay<String?>(value: nil)
    let birth = BehaviorRelay<String?>(value: nil)
    
    let isValidEmail = BehaviorRelay<Bool>(value: true)
    let isValidPassword = BehaviorRelay<Bool>(value: true)
    
    let isAlreadyExist = BehaviorRelay<Void>(value: ())
    let noUserExist = BehaviorRelay<Void>(value: ())

    init(useCase: SignUpUseCase) {
        self.useCase = useCase
    }

    deinit { Log.i(self) }
    
    private func checkValidEmail(email: String) {
        isValidEmail.accept(email.isValidEmail)
        if email.isValidEmail {
            self.email.accept(email)
        }
    }
    
    private func checkValidPassword(password: String) {
        isValidPassword.accept(password.count >= 6)
        if password.count >= 6 {
            self.password.accept(password)
        }
    }
    
    private func checkEmailExist() {
        guard let email = self.email.value,
              let password = self.password.value else {
            Log.e("Input error")
            return
        }
        if password.count < 6 { return }
        useCase.checkEmailExist(email: email)
    }
    
    private func registerUser() {
        guard let email = email.value, let password = password.value,
              let name = name.value, let birth = birth.value else {
            Log.e("Error")
            return
        }
        useCase.registUser(email: email, pw: password, name: name, birth: birth)
    }
}

extension SignUpVM {
    struct Input {
        var setEmail: Driver<String?> = .empty()
        var setPassword: Driver<String?> = .empty()
        var setName: Driver<String?> = .empty()
        var setBirth: Driver<String?> = .empty()
        var checkExist: Driver<Void> = .empty()
        var registUser: Driver<Void> = .empty()
    }

    struct Output {
        let email: Driver<String?>
        let password: Driver<String?>
        let name: Driver<String?>
        let birth: Driver<String?>
        
        let isValidEmail: Driver<Bool>
        let isValidPassword: Driver<Bool>
        
        let isAlreadyExist: Driver<Void>
        let noUserExist: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.setEmail
            .drive(onNext: { [weak self] email in
                guard let self = self, let email = email else { return }
                self.checkValidEmail(email: email)
            }).disposed(by: disposeBag)
        input.setPassword
            .drive(onNext: { [weak self] password in
                guard let self = self, let password = password else { return }
                self.checkValidPassword(password: password)
            }).disposed(by: disposeBag)
        
        input.checkExist
            .drive(onNext: { [weak self] _ in
                self?.checkEmailExist()
            }).disposed(by: disposeBag)
        
        return Output(email: email.asDriver(),
                      password: password.asDriver(),
                      name: name.asDriver(),
                      birth: birth.asDriver(),
                      
                      isValidEmail: isValidEmail.asDriver(),
                      isValidPassword: isValidPassword.asDriver(),
                      
                      isAlreadyExist: isAlreadyExist.asDriver(),
                      noUserExist: noUserExist.asDriver()
        )
    }
}
