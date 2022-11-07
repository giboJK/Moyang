//
//  MyPrayDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/04.
//

import RxSwift
import RxCocoa

class MyPrayDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    
    let useCase: MyPrayUseCase
    
    let prayID: String
    var myPray: MyPray!
    
    // MARK: - Data
    let groupName = BehaviorRelay<String>(value: "")
    let title = BehaviorRelay<String?>(value: nil)
    
    
    // MARK: - Events
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    
    let deletePraySuccess = BehaviorRelay<Void>(value: ())
    let deletePrayFailure = BehaviorRelay<Void>(value: ())
    
    
    // MARK: - VM
    let changeAndAnswerVM = BehaviorRelay<ChangeAndAnswerVM?>(value: nil)
    
    init(useCase: MyPrayUseCase, prayID: String) {
        self.useCase = useCase
        self.prayID = prayID
        
        bind()
    }
    
    deinit { Log.i(self) }
    
        
    private func bind() {
        useCase.myPrayList
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                if let pray = list.first(where: { $0.prayID == self.prayID }) {
                    self.setData(data: pray)
                }
            }).disposed(by: disposeBag)
        
        useCase.updatePraySuccess
            .bind(to: updatePraySuccess)
            .disposed(by: disposeBag)
        
        useCase.updatePrayFailure
            .bind(to: updatePrayFailure)
            .disposed(by: disposeBag)
        
        useCase.deletePraySuccess
            .bind(to: deletePraySuccess)
            .disposed(by: disposeBag)
        
        useCase.deletePrayFailure
            .bind(to: deletePrayFailure)
            .disposed(by: disposeBag)
    }
    
    private func setData(data: MyPray) {
        self.myPray = data
    }
    
    private func setChangeAndAnswerVM() {
//        changeAndAnswerVM.accept(ChangeAndAnswerVM(useCase: useCase, userID: userID, prayID: prayID))
    }
    
    private func updatePray() {
        guard let pray = self.title.value else { return }
//        useCase.updatePray(prayID: prayID, pray: pray)
    }
    
    private func deletePray() {
        useCase.deletePray(prayID: prayID)
    }
}

extension MyPrayDetailVM {
    struct Input {
        var setTitle: Driver<String?> = .empty()
        var updatePray: Driver<Void> = .empty()
        var deletePray: Driver<Void> = .empty()
    }

    struct Output {
        let groupName: Driver<String>
        let title: Driver<String?>
        
        let updatePraySuccess: Driver<Void>
        let updatePrayFailure: Driver<Void>
        
        let deletePraySuccess: Driver<Void>
        let deletePrayFailure: Driver<Void>
        
        let changeAndAnswerVM: Driver<ChangeAndAnswerVM?>
    }

    func transform(input: Input) -> Output {
        input.setTitle.skip(1)
            .drive(title)
            .disposed(by: disposeBag)
        
        input.updatePray
            .drive(onNext: { [weak self] _ in
                self?.updatePray()
            }).disposed(by: disposeBag)
        
        input.deletePray
            .drive(onNext: { [weak self] _ in
                self?.deletePray()
            }).disposed(by: disposeBag)
        
        
        return Output(
            groupName: groupName.asDriver(),
            title: title.asDriver(),
            
            
            updatePraySuccess: updatePraySuccess.asDriver(),
            updatePrayFailure: updatePrayFailure.asDriver(),
            deletePraySuccess: deletePraySuccess.asDriver(),
            deletePrayFailure: deletePrayFailure.asDriver(),
            
            changeAndAnswerVM: changeAndAnswerVM.asDriver()
        )
    }
}
