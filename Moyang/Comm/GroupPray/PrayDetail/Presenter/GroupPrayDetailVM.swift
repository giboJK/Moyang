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
    
    let isMyPray = BehaviorRelay<Bool>(value: false)
    let groupName = BehaviorRelay<String>(value: "")
    let date = BehaviorRelay<String>(value: "")
    let pray = BehaviorRelay<String?>(value: nil)
    let newTag = BehaviorRelay<String?>(value: nil)
    let tagList = BehaviorRelay<[String]>(value: [])
    let isSecret = BehaviorRelay<Bool>(value: false)
    let changes = BehaviorRelay<[PrayChange]>(value: [])
    let answers = BehaviorRelay<[PrayAnswer]>(value: [])
    
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    
    let deletePraySuccess = BehaviorRelay<Void>(value: ())
    let deletePrayFailure = BehaviorRelay<Void>(value: ())
    
    let prayPlusAndChangeVM = BehaviorRelay<PrayPlusAndChangeVM?>(value: nil)
    
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
        
        if userID == UserData.shared.userInfo?.id {
            isMyPray.accept(true)
        }
        groupName.accept(UserData.shared.groupInfo?.groupName ?? "")
    }
    
    private func setData(data: GroupIndividualPray) {
        self.groupIndividualPray = data
        date.accept(data.latestDate.isoToDateString() ?? "")
        pray.accept(data.pray)
        tagList.accept(data.tags)
        isSecret.accept(data.isSecret)
    }
    
    private func updatePray() {
        guard let pray = self.pray.value else { return }
        useCase.updatePray(prayID: prayID, pray: pray, tags: tagList.value, isSecret: isSecret.value)
    }
    
    private func deletePray() {
        useCase.deletePray(prayID: prayID)
    }
}

extension GroupPrayDetailVM {
    struct Input {
        var setPray: Driver<String?> = .empty()
        var updatePray: Driver<Void> = .empty()
        var setTag: Driver<String?> = .empty()
        var addTag: Driver<Void> = .empty()
        var deleteTag: Driver<IndexPath?> = .empty()
        var toggleIsSecret: Driver<Void> = .empty()
        var deletePray: Driver<Void> = .empty()
        var didTapPrayPlusAndChangeButton: Driver<Void> = .empty()
    }

    struct Output {
        let isMyPray: Driver<Bool>
        
        let groupName: Driver<String>
        let date: Driver<String>
        let pray: Driver<String?>
        let newTag: Driver<String?>
        let tagList: Driver<[String]>
        let isSecret: Driver<Bool>
        let changes: Driver<[PrayChange]>
        let answers: Driver<[PrayAnswer]>
        
        let updatePraySuccess: Driver<Void>
        let updatePrayFailure: Driver<Void>
        
        let deletePraySuccess: Driver<Void>
        let deletePrayFailure: Driver<Void>
        
        let prayPlusAndChangeVM: Driver<PrayPlusAndChangeVM?>
    }

    func transform(input: Input) -> Output {
        input.setPray
            .skip(1)
            .drive(pray)
            .disposed(by: disposeBag)
        
        input.updatePray
            .drive(onNext: { [weak self] _ in
                self?.updatePray()
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
        
        input.deletePray
            .drive(onNext: { [weak self] _ in
                self?.deletePray()
            }).disposed(by: disposeBag)
        
        input.didTapPrayPlusAndChangeButton
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.prayPlusAndChangeVM.accept(PrayPlusAndChangeVM(useCase: self.useCase,
                                                                    prayID: self.prayID,
                                                                    userID: self.userID))
            }).disposed(by: disposeBag)
        
        return Output(isMyPray: isMyPray.asDriver(),
                      
                      groupName: groupName.asDriver(),
                      date: date.asDriver(),
                      pray: pray.asDriver(),
                      newTag: newTag.asDriver(),
                      tagList: tagList.asDriver(),
                      isSecret: isSecret.asDriver(),
                      changes: changes.asDriver(),
                      answers: answers.asDriver(),
                      
                      updatePraySuccess: updatePraySuccess.asDriver(),
                      updatePrayFailure: updatePrayFailure.asDriver(),
                      
                      deletePraySuccess: deletePraySuccess.asDriver(),
                      deletePrayFailure: deletePrayFailure.asDriver(),
                      
                      prayPlusAndChangeVM: prayPlusAndChangeVM.asDriver()
        )
    }
}
