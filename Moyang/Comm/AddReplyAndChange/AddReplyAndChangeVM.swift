//
//  PrayPlusAndChangeVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/02.
//

import RxSwift
import RxCocoa

class AddReplyAndChangeVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: PrayUseCase
    let prayID: String
    let userID: String
    
    let title = BehaviorRelay<String>(value: "")
    var isAnswer = false
    
    let content = BehaviorRelay<String?>(value: nil)
    
    let plusPraySuccess = BehaviorRelay<Void>(value: ())
    let plusPrayFailure = BehaviorRelay<Void>(value: ())
    let addChangeSuccess = BehaviorRelay<Void>(value: ())
    let addChangeFailure = BehaviorRelay<Void>(value: ())
    let addReplySuccess = BehaviorRelay<Void>(value: ())
    let addReplyFailure = BehaviorRelay<Void>(value: ())
    let addAnswerSuccess = BehaviorRelay<Void>(value: ())
    let addAnswerFailure = BehaviorRelay<Void>(value: ())
    
    let bibleSelectVM = BehaviorRelay<BibleSelectVM?>(value: nil)
    
    var isMe = false
    
    init(useCase: PrayUseCase, prayID: String, userID: String, isAnswer: Bool = false) {
        self.useCase = useCase
        self.prayID = prayID
        self.userID = userID
        self.isAnswer = isAnswer
        
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.plusPraySuccess
            .bind(to: plusPraySuccess)
            .disposed(by: disposeBag)
        
        useCase.plusPrayFailure
            .bind(to: plusPrayFailure)
            .disposed(by: disposeBag)
        
        useCase.addChangeSuccess
            .bind(to: addChangeSuccess)
            .disposed(by: disposeBag)
        
        useCase.addChangeFailure
            .bind(to: addChangeFailure)
            .disposed(by: disposeBag)
        
        useCase.addReplySuccess
            .bind(to: addReplySuccess)
            .disposed(by: disposeBag)
        
        useCase.addReplyFailure
            .bind(to: addReplyFailure)
            .disposed(by: disposeBag)
        
        useCase.addAnswerSuccess
            .bind(to: addAnswerSuccess)
            .disposed(by: disposeBag)
        
        useCase.addAnswerFailure
            .bind(to: addAnswerFailure)
            .disposed(by: disposeBag)
        
        guard let myInfo = UserData.shared.userInfo else { Log.e(""); return }
        if userID == myInfo.id {
            if isAnswer {
                title.accept("응답 기록하기")
            } else {
                title.accept("변화 기록하기")
            }
            isMe = true
        } else {
            title.accept("기도문 더하기")
        }
    }
    
    private func addReply() {
        guard let content = content.value else { Log.e("No content"); return }
        useCase.addReply(userID: userID, prayID: prayID, reply: content)
    }
    
    private func addChange() {
        guard let content = content.value else { Log.e("No content"); return }
        useCase.addChange(prayID: prayID, content: content)
    }
    
    private func addAnswer() {
        guard let content = content.value else { Log.e("No content"); return }
        useCase.addAnswer(prayID: prayID, answer: content)
    }
    
    private func setBibleSelectVM() {
        bibleSelectVM.accept(BibleSelectVM(useCase: useCase))
    }
}

extension AddReplyAndChangeVM {
    struct Input {
        var setContent: Driver<String?> = .empty()
        var saveContent: Driver<Void> = .empty()
        var setBible: Driver<Void> = .empty()
    }

    struct Output {
        let title: Driver<String>
        let content: Driver<String?>
        let plusPraySuccess: Driver<Void>
        let plusPrayFailure: Driver<Void>
        let addChangeSuccess: Driver<Void>
        let addChangeFailure: Driver<Void>
        let addReplySuccess: Driver<Void>
        let addReplyFailure: Driver<Void>
        let addAnswerSuccess: Driver<Void>
        let addAnswerFailure: Driver<Void>
        
        let bibleSelectVM: Driver<BibleSelectVM?>
    }

    func transform(input: Input) -> Output {
        input.setContent
            .drive(content)
            .disposed(by: disposeBag)
        
        input.saveContent
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.isMe {
                    if self.isAnswer {
                        self.addAnswer()
                    } else {
                        self.addChange()
                    }
                } else {
                    self.addReply()
                }
            }).disposed(by: disposeBag)
        
        input.setBible
            .drive(onNext: { [weak self] _ in
                self?.setBibleSelectVM()
            }).disposed(by: disposeBag)
        
        return Output(title: title.asDriver(),
                      content: content.asDriver(),
                      plusPraySuccess: plusPraySuccess.asDriver(),
                      plusPrayFailure: plusPrayFailure.asDriver(),
                      addChangeSuccess: addChangeSuccess.asDriver(),
                      addChangeFailure: addChangeFailure.asDriver(),
                      addReplySuccess: addReplySuccess.asDriver(),
                      addReplyFailure: addReplyFailure.asDriver(),
                      addAnswerSuccess: addAnswerSuccess.asDriver(),
                      addAnswerFailure: addAnswerFailure.asDriver(),
                      
                      bibleSelectVM: bibleSelectVM.asDriver()
        )
    }
}
