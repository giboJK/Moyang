//
//  GroupPrayDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/04.
//

import RxSwift
import RxCocoa

class GroupPrayDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: PrayUseCase
    let userID: String
    let prayID: String
    var groupIndividualPray: GroupIndividualPray!
    
    let isEditing = BehaviorRelay<Bool>(value: false)
    let groupName = BehaviorRelay<String>(value: "")
    let pray = BehaviorRelay<String?>(value: nil)
    let newTag = BehaviorRelay<String?>(value: nil)
    let tagList = BehaviorRelay<[String]>(value: [])
    let isSecret = BehaviorRelay<Bool>(value: false)
    
    let updatingPraySuccess = BehaviorRelay<Void>(value: ())
    let updatingPrayFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: PrayUseCase, userID: String, prayID: String) {
        self.useCase = useCase
        self.userID = userID
        self.prayID = prayID
        
        bind()
    }
    
    deinit { Log.i(self) }
        
    private func bind() {
        useCase.memberPrayList
            .subscribe(onNext: { [weak self] dict in
                guard let self = self else { return }
                if let list = dict[self.userID] {
                    if let pray = list.first(where: { $0.prayID == self.prayID }) {
                        self.setData(data: pray)
                    }
                }
            }).disposed(by: disposeBag)
        groupName.accept(UserData.shared.groupInfo?.groupName ?? "")
    }
    
    private func setData(data: GroupIndividualPray) {
        self.groupIndividualPray = data
        pray.accept(data.pray)
        tagList.accept(data.tags)
        isSecret.accept(data.isSecret)
    }
    
    private func updatingPray() {
    }
}

extension GroupPrayDetailVM {
    struct Input {
        var setPray: Driver<String?> = .empty()
        var updatingPray: Driver<Void> = .empty()
        var setTag: Driver<String?> = .empty()
        var addTag: Driver<Void> = .empty()
        var deleteTag: Driver<IndexPath?> = .empty()
        var toggleIsSecret: Driver<Void> = .empty()
        var toggleIsEditing: Driver<Void> = .empty()
    }

    struct Output {
        let groupName: Driver<String>
        let pray: Driver<String?>
        let newTag: Driver<String?>
        let tagList: Driver<[String]>
        let isSecret: Driver<Bool>
        let isEditing: Driver<Bool>
        let updatingPraySuccess: Driver<Void>
        let updatingPrayFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.setPray
            .skip(1)
            .drive(pray)
            .disposed(by: disposeBag)
        
        input.updatingPray
            .drive(onNext: { [weak self] _ in
                self?.updatingPray()
            }).disposed(by: disposeBag)
        
        input.setTag
            .skip(1)
            .drive(onNext: { [weak self] tag in
                guard let tag = tag else { return }
                self?.newTag.accept(String(tag.prefix(10)))
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
        
        input.toggleIsEditing
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isEditing.accept(!self.isEditing.value)
            }).disposed(by: disposeBag)
        
        return Output(groupName: groupName.asDriver(),
                      pray: pray.asDriver(),
                      newTag: newTag.asDriver(),
                      tagList: tagList.asDriver(),
                      isSecret: isSecret.asDriver(),
                      isEditing: isEditing.asDriver(),
                      updatingPraySuccess: updatingPraySuccess.asDriver(),
                      updatingPrayFailure: updatingPrayFailure.asDriver()
        )
    }
}
