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
    
    let groupName = BehaviorRelay<String>(value: "")
    let newPray = BehaviorRelay<String?>(value: nil)
    let newTag = BehaviorRelay<String?>(value: nil)
    let tagList = BehaviorRelay<[String]>(value: [])
    let isSecret = BehaviorRelay<Bool>(value: false)
    
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
    
    func clearNewTag() {
        tagList.accept([])
    }
    
    private func autoSave() {
        UserData.shared.autoSavedPray = newPray.value
        UserData.shared.autoSavedTags = tagList.value
    }
    
    private func loadAutoSave() {
        if let autoSavedPray = UserData.shared.autoSavedPray {
            newPray.accept(autoSavedPray)
        }
        if let autoSavedTags = UserData.shared.autoSavedTags {
            tagList.accept(autoSavedTags)
        }
    }
    
    private func clearAutoSave() {
        UserData.shared.clearAutoSave()
    }
    
    private func addNewPray() {
        guard let pray = newPray.value else { Log.e(""); return }
        useCase.addPray(pray: pray, tags: tagList.value, isSecret: isSecret.value)
    }
}

extension NewPrayVM {
    struct Input {
        var setPray: Driver<String?> = .empty()
        var saveNewPray: Driver<Void> = .empty()
        var setTag: Driver<String?> = .empty()
        var addTag: Driver<Void> = .empty()
        var deleteTag: Driver<IndexPath?> = .empty()
        var loadAutoPray: Driver<Bool> = .empty()
        var toggleIsSecret: Driver<Void> = .empty()
    }

    struct Output {
        let groupName: Driver<String>
        let newPray: Driver<String?>
        let newTag: Driver<String?>
        let tagList: Driver<[String]>
        let addingNewPraySuccess: Driver<Void>
        let addingNewPrayFailure: Driver<Void>
        let isSecret: Driver<Bool>
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
        
        input.setTag
            .skip(1)
            .drive(onNext: { [weak self] tag in
                guard let tag = tag else { return }
                self?.newTag.accept(String(tag.prefix(20)))
            }).disposed(by: disposeBag)
        
        input.addTag
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                var currnetTags = self.tagList.value
                if let tag = self.newTag.value,
                   !tag.isEmpty, !tag.trimmingCharacters(in: .whitespaces).isEmpty {
                    currnetTags.append(tag)
                    self.tagList.accept(currnetTags)
                    self.newTag.accept(nil)
                    self.autoSave()
                }
            }).disposed(by: disposeBag)
        
        input.deleteTag
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { Log.e(""); return }
                guard let indexPath = indexPath else { Log.e(""); return }
                var currnetTags = self.tagList.value
                if currnetTags.count > indexPath.row {
                    currnetTags.remove(at: indexPath.row)
                    self.tagList.accept(currnetTags)
                    self.autoSave()
                }
            }).disposed(by: disposeBag)
        
        input.loadAutoPray
            .drive(onNext: { [weak self] willBeAppeared in
                if willBeAppeared {
                    self?.loadAutoSave()
                }
            }).disposed(by: disposeBag)
        
        input.toggleIsSecret
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isSecret.accept(!self.isSecret.value)
            }).disposed(by: disposeBag)
        return Output(groupName: groupName.asDriver(),
                      newPray: newPray.asDriver(),
                      newTag: newTag.asDriver(),
                      tagList: tagList.asDriver(),
                      addingNewPraySuccess: addingNewPraySuccess.asDriver(),
                      addingNewPrayFailure: addingNewPrayFailure.asDriver(),
                      isSecret: isSecret.asDriver()
        )
    }
}
