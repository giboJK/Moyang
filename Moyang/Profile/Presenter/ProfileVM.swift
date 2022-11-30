//
//  ProfileVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/19.
//

import RxSwift
import RxCocoa

class ProfileVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: ProfileUseCase

    let name = BehaviorRelay<String>(value: "")
    let email = BehaviorRelay<String>(value: "")
    
    init(useCase: ProfileUseCase) {
        self.useCase = useCase
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        
    }
    
    private func setData() {
        
    }
    
    private func delelteUser() {
        useCase.deleteUser()
    }
}

extension ProfileVM {
    struct Input {
        let deleteAccount: Driver<Void>
    }

    struct Output {
        let name: Driver<String>
        let email: Driver<String>
    }

    func transform(input: Input) -> Output {
        input.deleteAccount
            .drive(onNext: { [weak self] _ in
                self?.delelteUser()
            }).disposed(by: disposeBag)
        
        return Output(name: name.asDriver(),
                      email: email.asDriver())
    }
}
