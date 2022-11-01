//
//  NewPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/01.
//

import RxSwift
import RxCocoa

class NewPrayVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: MyPrayUseCase
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let guide = BehaviorRelay<String>(value: "")
    let groupName = BehaviorRelay<String>(value: "")
    let newPray = BehaviorRelay<String?>(value: nil)
    
    let addingNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addingNewPrayFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: MyPrayUseCase) {
        self.useCase = useCase
        bind()
        setGroupName()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.addNewPraySuccess
            .bind(to: addingNewPraySuccess)
            .disposed(by: disposeBag)
        
        useCase.addNewPraySuccess
            .skip(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.clearAutoSave()
            }).disposed(by: disposeBag)
        
        useCase.addNewPrayFailure
            .bind(to: addingNewPrayFailure)
            .disposed(by: disposeBag)
    }
    
    private func setGroupName() {
        if let groupInfo = UserData.shared.groupInfo {
            groupName.accept(groupInfo.groupName)
        }
    }
    
    private func autoSave() {
        UserData.shared.autoSavedPray = newPray.value
    }
    
    private func loadAutoSave() {
        if let autoSavedPray = UserData.shared.autoSavedPray {
            newPray.accept(autoSavedPray)
        }
    }
    
    private func clearAutoSave() {
        UserData.shared.clearAutoSave()
    }
    
    private func addNewPray() {
        guard let pray = newPray.value else { Log.e(""); return }
//        useCase.addPray(pray: pray, tags: tagList.value, isSecret: isSecret.value)
    }
}

extension NewPrayVM {
    struct Input {
        var setPray: Driver<String?> = .empty()
        var saveNewPray: Driver<Void> = .empty()
        var loadAutoPray: Driver<Bool> = .empty()
    }

    struct Output {
        let guide: Driver<String>
        let groupName: Driver<String>
        let newPray: Driver<String?>
        let addingNewPraySuccess: Driver<Void>
        let addingNewPrayFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.setPray
            .drive(newPray)
            .disposed(by: disposeBag)
        
        input.setPray
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.autoSave()
            }).disposed(by: disposeBag)
        
        input.saveNewPray
            .drive(onNext: { [weak self] _ in
                self?.addNewPray()
            }).disposed(by: disposeBag)
        
        input.loadAutoPray
            .drive(onNext: { [weak self] willBeAppeared in
                if willBeAppeared {
                    self?.loadAutoSave()
                }
            }).disposed(by: disposeBag)
        
        return Output(guide: guide.asDriver(),
                      groupName: groupName.asDriver(),
                      newPray: newPray.asDriver(),
                      addingNewPraySuccess: addingNewPraySuccess.asDriver(),
                      addingNewPrayFailure: addingNewPrayFailure.asDriver()
        )
    }
}
