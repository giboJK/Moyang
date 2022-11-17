//
//  NewGroupVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/16.
//

import RxSwift
import RxCocoa

class NewGroupVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: GroupUseCase
    
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    let isSaveEnabled = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Data
    let name = BehaviorRelay<String?>(value: nil)
    let desc = BehaviorRelay<String?>(value: nil)
    
    // MARK: - Event
    let registerGroupSuccess = BehaviorRelay<Void>(value: ())
    let registerGroupFailure = BehaviorRelay<Void>(value: ())
    
    
    init(useCase: GroupUseCase) {
        self.useCase = useCase
        
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        Observable.combineLatest(name, desc)
            .subscribe(onNext: { [weak self] (name, desc) in
                guard let name = name, let desc = desc else {
                    self?.isSaveEnabled.accept(false)
                    return
                }
                self?.isSaveEnabled.accept( !(name.isEmpty || desc.isEmpty) )
            }).disposed(by: disposeBag)
        
        useCase.registerGroupSuccess
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                NotificationCenter.default.post(name: NSNotification.Name.ReloadGroupList,
                                                object: nil, userInfo: nil)
                self?.registerGroupSuccess.accept(())
                
            }).disposed(by: disposeBag)
        
        useCase.registerGroupFailure
            .bind(to: registerGroupFailure).disposed(by: disposeBag)
    }
    
    private func registerGroup() {
        guard let name = name.value, let desc = desc.value else {
            return
        }
        useCase.registerGroup(name: name, desc: desc)
    }
}

extension NewGroupVM {
    struct Input {
        let setName: Driver<String?>
        let setDesc: Driver<String?>
        let confirm: Driver<Void>
    }

    struct Output {
        // MARK: - State
        let isNetworking: Driver<Bool>
        let isSaveEnabled: Driver<Bool>
        
        // MARK: - Data
        let name: Driver<String?>
        let desc: Driver<String?>
        
        // MARK: - Event
        let registerGroupSuccess: Driver<Void>
        let registerGroupFailure: Driver<Void>
        
    }

    func transform(input: Input) -> Output {
        input.setName.skip(1)
            .drive(name)
            .disposed(by: disposeBag)
        
        input.setDesc.skip(1)
            .drive(desc)
            .disposed(by: disposeBag)
        
        input.confirm
            .drive(onNext: { [weak self] _ in
                self?.registerGroup()
            }).disposed(by: disposeBag)
        
        return Output(isNetworking: isNetworking.asDriver(),
                      isSaveEnabled: isSaveEnabled.asDriver(),
                      
                      name: name.asDriver(),
                      desc: desc.asDriver(),
                      
                      registerGroupSuccess: registerGroupSuccess.asDriver(),
                      registerGroupFailure: registerGroupFailure.asDriver()
        )
    }
}
