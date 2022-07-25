//
//  PrayWithAndChangeVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/02.
//

import RxSwift
import RxCocoa

class PrayWithAndChangeVM: VMType {
    typealias PrayItem = CommunityMainVM.GroupIndividualPrayItem
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    let prayItem: PrayItem
    
    let title = BehaviorRelay<String>(value: "")
    let memberName = BehaviorRelay<String>(value: "")
    let date = BehaviorRelay<String>(value: "")
    let parentPray = BehaviorRelay<String>(value: "")
    let parentTagList = BehaviorRelay<[String]>(value: [])
    
    let reply = BehaviorRelay<String?>(value: nil)
    
    let addingReplySuccess = BehaviorRelay<Void>(value: ())
    let addingReplyFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: CommunityMainUseCase, prayItme: PrayItem) {
        self.useCase = useCase
        self.prayItem = prayItme
        
        bind()
        setData(data: prayItme)
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.addingReplySuccess
            .bind(to: addingReplySuccess)
            .disposed(by: disposeBag)
        
        useCase.addingReplyFailure
            .bind(to: addingReplyFailure)
            .disposed(by: disposeBag)
    }
    
    private func setData(data: PrayItem) {
        memberName.accept(data.name)
//        date.accept(data.date)
//        parentPray.accept(data.pray)
//        parentTagList.accept(data.tags)
        
        guard let myInfo = UserData.shared.myInfo else { Log.e(""); return }
        if data.memberID == myInfo.id {
            title.accept("변화 기록하기")
        } else {
            title.accept("같이 기도하기")
        }
    }
    
    private func addReply() {
//        guard let myInfo = UserData.shared.myInfo else { Log.e(""); return }
//        guard let reply = reply.value else { Log.e(""); return }
//
//        let order = prayItem.replys.filter { reply in
//            reply.memberID == myInfo.id
//        }.count
//        useCase.addReply(memberAuth: prayItem.memberAuth,
//                         email: prayItem.memberEmail,
//                         prayID: prayItem.prayID,
//                         reply: reply,
//                         date: Date().toString(format: "yyyy-MM-dd hh:mm:ss a"),
//                         order: order + 1)
    }
}

extension PrayWithAndChangeVM {
    struct Input {
        var setReply: Driver<String?> = .empty()
        var saveReply: Driver<Void> = .empty()
    }

    struct Output {
        let title: Driver<String>
        let memberName: Driver<String>
        let date: Driver<String>
        let parentPray: Driver<String>
        let parentTagList: Driver<[String]>
        let reply: Driver<String?>
        let addingReplySuccess: Driver<Void>
        let addingReplyFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.setReply
            .drive(reply)
            .disposed(by: disposeBag)
        
        input.saveReply
            .drive(onNext: { [weak self] _ in
                self?.addReply()
            }).disposed(by: disposeBag)
        
        
        return Output(title: title.asDriver(),
                      memberName: memberName.asDriver(),
                      date: date.asDriver(),
                      parentPray: parentPray.asDriver(),
                      parentTagList: parentTagList.asDriver(),
                      reply: reply.asDriver(),
                      addingReplySuccess: addingReplySuccess.asDriver(),
                      addingReplyFailure: addingReplyFailure.asDriver()
        )
    }
}
