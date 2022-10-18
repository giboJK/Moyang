//
//  PrayReplyDetailVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/07.
//

import RxSwift
import RxCocoa

class PrayReplyDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    private let replys: [PrayReply]
    let useCase: MyPrayUseCase
    let userID: String
    let prayID: String
    var indexToDelete: Int = -1
    
    
    let itemList = BehaviorRelay<[ReplyItem]>(value: [])
    let isDateSorted = BehaviorRelay<Bool>(value: true)
    let askingDeletion = BehaviorRelay<Void>(value: ())
    let deleteReplySuccess = BehaviorRelay<Void>(value: ())
    let deleteReplyFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: MyPrayUseCase, userID: String, prayID: String, replys: [PrayReply]) {
        self.useCase = useCase
        self.userID = userID
        self.prayID = prayID
        self.replys = replys.sorted(by: { $0.createDate > $1.createDate })

        bind()
        setData()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        useCase.deleteReplySuccess
            .bind(to: deleteReplySuccess)
            .disposed(by: disposeBag)
        
        useCase.deleteReplyFailure
            .bind(to: deleteReplyFailure)
            .disposed(by: disposeBag)
    }
    
    private func setData() {
        var itemList = [ReplyItem]()
        replys.forEach { reply in
            itemList.append(ReplyItem(id: reply.id,
                                      memberID: reply.memberID,
                                      name: reply.name,
                                      reply: reply.reply,
                                      date: reply.createDate))
        }
        self.itemList.accept(itemList)
    }
    
    func deleteReply(index: Int) {
        indexToDelete = index
        askingDeletion.accept(())
    }
    
    private func deleteReply() {
        let replyID = itemList.value[indexToDelete].id
        useCase.deleteReply(replyID: replyID, userID: userID, prayID: prayID)
    }
    
    func updateReply(index: Int, reply: String) {
        let replyID = itemList.value[index].id
        useCase.updateReply(replyID: replyID, reply: reply, userID: userID, prayID: prayID)
    }
}

extension PrayReplyDetailVM {
    struct Input {
        var orderByDate: Driver<Void> = .empty()
        var orderByName: Driver<Void> = .empty()
        var deleteConfirm: Driver<Void> = .empty()
    }
    
    struct Output {
        let itemList: Driver<[ReplyItem]>
        let isDateSorted: Driver<Bool>
        let askingDeletion: Driver<Void>
        let deleteReplySuccess: Driver<Void>
        let deleteReplyFailure: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        input.orderByDate
            .map { _ in true }
            .drive(isDateSorted)
            .disposed(by: disposeBag)
        
        input.orderByName
            .map { _ in false }
            .drive(isDateSorted)
            .disposed(by: disposeBag)
        
        input.deleteConfirm
            .drive(onNext: { [weak self] _ in
                self?.deleteReply()
            }).disposed(by: disposeBag)
        
        return Output(itemList: itemList.asDriver(),
                      isDateSorted: isDateSorted.asDriver(),
                      askingDeletion: askingDeletion.asDriver(),
                      deleteReplySuccess: deleteReplySuccess.asDriver(),
                      deleteReplyFailure: deleteReplyFailure.asDriver()
        )
    }
}

extension PrayReplyDetailVM {
    struct ReplyItem {
        let id: String
        let memberID: String
        let name: String
        let reply: String
        let date: String
        let isHeader: Bool
        
        init(id: String,
             memberID: String,
             name: String,
             reply: String,
             date: String,
             isHeader: Bool = false
        ) {
            self.id = id
            self.memberID = memberID
            self.name = name
            self.reply = reply
            self.date = date
            self.isHeader = isHeader
        }
    }
}
