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
    
    let isMyPray = BehaviorRelay<Bool>(value: false)
    let memberName = BehaviorRelay<String>(value: "내 기도")
    let groupName = BehaviorRelay<String>(value: "")
    let date = BehaviorRelay<String>(value: "")
    let pray = BehaviorRelay<String?>(value: nil)
    let changes = BehaviorRelay<[PrayChange]>(value: [])
    let answers = BehaviorRelay<[PrayAnswer]>(value: [])
    
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    
    let deletePraySuccess = BehaviorRelay<Void>(value: ())
    let deletePrayFailure = BehaviorRelay<Void>(value: ())
    
    
    let prayPlusAndChangeVM = BehaviorRelay<AddReplyAndChangeVM?>(value: nil)
    let prayReactionDetailVM = BehaviorRelay<PrayReactionDetailVM?>(value: nil)
    let prayReplyDetailVM = BehaviorRelay<PrayReplyDetailVM?>(value: nil)
    let changeAndAnswerVM = BehaviorRelay<ChangeAndAnswerVM?>(value: nil)
    
    init(useCase: MyPrayUseCase, prayID: String) {
        self.useCase = useCase
        self.prayID = prayID
        
        bind()
    }
    
    deinit {
        Log.i(self)
    }
    
    func deinitVMs() {
        prayPlusAndChangeVM.accept(nil)
        prayReactionDetailVM.accept(nil)
        prayReplyDetailVM.accept(nil)
        changeAndAnswerVM.accept(nil)
    }
        
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
        date.accept(data.latestDate.isoToDateString() ?? "")
//        pray.accept(data.pray)
//        tagList.accept(data.tags)
//        isSecret.accept(data.isSecret)
//        reactions.accept(data.reactions)
//        changes.accept(data.changes)
//        answers.accept(data.answers)
//        replys.accept(data.replys)
        
        memberName.accept("내 기도")
    }
    
    private func setChangeAndAnswerVM() {
//        changeAndAnswerVM.accept(ChangeAndAnswerVM(useCase: useCase, userID: userID, prayID: prayID))
    }
    
    private func updatePray() {
        guard let pray = self.pray.value else { return }
//        useCase.updatePray(prayID: prayID, pray: pray)
    }
    
    private func deletePray() {
        useCase.deletePray(prayID: prayID)
    }
    
    func addReaction(type: PrayReactionType) {
//        useCase.addReaction(userID: userID, prayID: prayID, type: type.rawValue)
    }
}

extension MyPrayDetailVM {
    struct Input {
        var setPray: Driver<String?> = .empty()
        var updatePray: Driver<Void> = .empty()
        var deletePray: Driver<Void> = .empty()
        
        var addChange: Driver<Void> = .empty()
        var addAnswer: Driver<Void> = .empty()
    }

    struct Output {
        let memberName: Driver<String>
        let groupName: Driver<String>
        let date: Driver<String>
        let pray: Driver<String?>
        
        let changes: Driver<[PrayChange]>
        let answers: Driver<[PrayAnswer]>
        
        let updatePraySuccess: Driver<Void>
        let updatePrayFailure: Driver<Void>
        
        let deletePraySuccess: Driver<Void>
        let deletePrayFailure: Driver<Void>
        
        let prayPlusAndChangeVM: Driver<AddReplyAndChangeVM?>
        let prayReplyDetailVM: Driver<PrayReplyDetailVM?>
        let changeAndAnswerVM: Driver<ChangeAndAnswerVM?>
    }

    func transform(input: Input) -> Output {
        input.setPray.skip(1)
            .drive(pray)
            .disposed(by: disposeBag)
        
        input.updatePray
            .drive(onNext: { [weak self] _ in
                self?.updatePray()
            }).disposed(by: disposeBag)
        
        input.deletePray
            .drive(onNext: { [weak self] _ in
                self?.deletePray()
            }).disposed(by: disposeBag)
        
        input.addChange
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
//                self.prayPlusAndChangeVM.accept(AddReplyAndChangeVM(useCase: self.useCase,
//                                                                    bibleUseCase: self.bibleUseCase,
//                                                                    prayID: self.prayID,
//                                                                    userID: self.userID))
            }).disposed(by: disposeBag)
        
        input.addAnswer
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
//                self.prayPlusAndChangeVM.accept(AddReplyAndChangeVM(useCase: self.useCase,
//                                                                    bibleUseCase: self.bibleUseCase,
//                                                                    prayID: self.prayID,
//                                                                    userID: self.userID,
//                                                                    isAnswer: true))
            }).disposed(by: disposeBag)
        
        return Output(
            memberName: memberName.asDriver(),
            groupName: groupName.asDriver(),
            date: date.asDriver(),
            pray: pray.asDriver(),
            changes: changes.asDriver(),
            answers: answers.asDriver(),
            updatePraySuccess: updatePraySuccess.asDriver(),
            updatePrayFailure: updatePrayFailure.asDriver(),
            deletePraySuccess: deletePraySuccess.asDriver(),
            deletePrayFailure: deletePrayFailure.asDriver(),
            prayPlusAndChangeVM: prayPlusAndChangeVM.asDriver(),
            prayReplyDetailVM: prayReplyDetailVM.asDriver(),
            changeAndAnswerVM: changeAndAnswerVM.asDriver()
        )
    }
}
