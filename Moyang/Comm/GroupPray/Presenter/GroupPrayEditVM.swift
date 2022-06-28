//
//  GroupPrayEditVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import RxSwift
import RxCocoa

class GroupPrayEditVM: VMType {
    typealias PrayItem = CommunityMainVM.GroupIndividualPrayItem
    var disposeBag: DisposeBag = DisposeBag()
    
    var useCase: GroupPrayUseCase
    
    let newPray = BehaviorRelay<String?>(value: nil)
    let newTag = BehaviorRelay<String?>(value: nil)
    let tagList = BehaviorRelay<[String]>(value: [])
    
    let editingPraySuccess = BehaviorRelay<Void>(value: ())
    let editingPrayFailure = BehaviorRelay<Void>(value: ())
    
    let isSecret = BehaviorRelay<Bool>(value: false)
    let isRequestPray = BehaviorRelay<Bool>(value: false)
    let prayID: String
    
    init(prayItem: PrayItem, useCase: GroupPrayUseCase) {
        self.prayID = prayItem.prayID
        self.useCase = useCase
        setInitialData(item: prayItem)
        bind()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        useCase.editingPraySuccess
            .bind(to: editingPraySuccess)
            .disposed(by: disposeBag)
        
        useCase.editingPrayFailure
            .bind(to: editingPrayFailure)
            .disposed(by: disposeBag)
    }
    
    private func setInitialData(item: PrayItem) {
        newPray.accept(item.pray)
        tagList.accept(item.tags)
        isSecret.accept(item.isSecret)
        isRequestPray.accept(item.isRequestPray)
    }
    
    private func editPray() {
        useCase.editPray(prayID: prayID,
                         pray: newPray.value!,
                         tags: tagList.value,
                         isSecret: isSecret.value,
                         isRequestPray: isRequestPray.value
        )
    }
}

extension GroupPrayEditVM {
    struct Input {
        var setPray: Driver<String?> = .empty()
        var editPray: Driver<Void> = .empty()
        var newTag: Driver<String?> = .empty()
        var setTag: Driver<String?> = .empty()
        var addTag: Driver<Void> = .empty()
        var deleteTag: Driver<IndexPath?> = .empty()
        var toggleIsSecret: Driver<Void> = .empty()
        var toggleIsRequestPray: Driver<Void> = .empty()
    }

    struct Output {
        let newPray: Driver<String?>
        let newTag: Driver<String?>
        let tagList: Driver<[String]>
        let editingPraySuccess: Driver<Void>
        let editingPrayFailure: Driver<Void>
        let isSecret: Driver<Bool>
        let isRequestPray: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        input.setPray
            .skip(1)
            .drive(newPray)
            .disposed(by: disposeBag)
        
        input.editPray
            .drive(onNext: { [weak self] _ in
                self?.editPray()
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
        
        return Output(newPray: newPray.asDriver(),
                      newTag: newTag.asDriver(),
                      tagList: tagList.asDriver(),
                      editingPraySuccess: editingPraySuccess.asDriver(),
                      editingPrayFailure: editingPrayFailure.asDriver(),
                      isSecret: isSecret.asDriver(),
                      isRequestPray: isRequestPray.asDriver()
        )
    }
}
