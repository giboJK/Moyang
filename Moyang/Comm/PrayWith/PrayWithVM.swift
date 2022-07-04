//
//  PrayWithVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/02.
//

import RxSwift
import RxCocoa

class PrayWithVM: VMType {
    typealias PrayItem = CommunityMainVM.GroupIndividualPrayItem
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    let prayItem: PrayItem
    
    let parentPray = BehaviorRelay<String>(value: "")
    let parentTagList = BehaviorRelay<[String]>(value: [])
    
    let newPray = BehaviorRelay<String?>(value: nil)
    let newTag = BehaviorRelay<String?>(value: nil)
    let tagList = BehaviorRelay<[String]>(value: [])
    
    let addingNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addingNewPrayFailure = BehaviorRelay<Void>(value: ())
    
    let isSecret = BehaviorRelay<Bool>(value: false)
    let isRequestPray = BehaviorRelay<Bool>(value: false)
    
    init(useCase: CommunityMainUseCase, prayItme: PrayItem) {
        self.useCase = useCase
        self.prayItem = prayItme
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.addingNewPraySuccess
            .bind(to: addingNewPraySuccess)
            .disposed(by: disposeBag)
        
        useCase.addingNewPraySuccess
            .skip(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.clearAutoSave()
            }).disposed(by: disposeBag)
        
        useCase.addingNewPrayFailure
            .bind(to: addingNewPrayFailure)
            .disposed(by: disposeBag)
    }
    
    private func addReply() {
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
    
    func clearNewTag() {
        tagList.accept([])
    }
    
}

extension PrayWithVM {
    struct Input {
        var setPray: Driver<String?> = .empty()
        var autoSave: Driver<Void> = .empty()
        var saveNewPray: Driver<Void> = .empty()
        var newTag: Driver<String?> = .empty()
        var setTag: Driver<String?> = .empty()
        var addTag: Driver<Void> = .empty()
        var deleteTag: Driver<IndexPath?> = .empty()
        var loadAutoPray: Driver<Bool> = .empty()
        var toggleIsSecret: Driver<Void> = .empty()
        var toggleIsRequestPray: Driver<Void> = .empty()
    }

    struct Output {
        let parentPray: Driver<String>
        let parentTagList: Driver<[String]>
        let newPray: Driver<String?>
        let newTag: Driver<String?>
        let tagList: Driver<[String]>
        let addingNewPraySuccess: Driver<Void>
        let addingNewPrayFailure: Driver<Void>
        let isSecret: Driver<Bool>
        let isRequestPray: Driver<Bool>
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
                self?.addReply()
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
        
        input.toggleIsRequestPray
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isRequestPray.accept(!self.isRequestPray.value)
            }).disposed(by: disposeBag)
        
        
        return Output(parentPray: parentPray.asDriver(),
                      parentTagList: parentTagList.asDriver(),
                      newPray: newPray.asDriver(),
                      newTag: newTag.asDriver(),
                      tagList: tagList.asDriver(),
                      addingNewPraySuccess: addingNewPraySuccess.asDriver(),
                      addingNewPrayFailure: addingNewPrayFailure.asDriver(),
                      isSecret: isSecret.asDriver(),
                      isRequestPray: isRequestPray.asDriver()
        )
    }
}
