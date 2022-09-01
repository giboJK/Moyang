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
    let useCase: PrayUseCase
    let userID: String
    let prayID: String
    
    let itemList = BehaviorRelay<[ReplyItem]>(value: [])
    let isDateSorted = BehaviorRelay<Bool>(value: true)
    
    init(useCase: PrayUseCase, userID: String, prayID: String, replys: [PrayReply]) {
        self.useCase = useCase
        self.userID = userID
        self.prayID = prayID
        self.replys = replys.sorted(by: { $0.createDate > $1.createDate })
        setData()
    }
    
    deinit { Log.i(self) }
    
    private func setData() {
        var itemList = [ReplyItem]()
        replys.forEach { reply in
            itemList.append(ReplyItem(memberID: reply.memberID,
                                      name: reply.name,
                                      reply: reply.reply,
                                      date: reply.createDate))
        }
        self.itemList.accept(itemList)
    }
    
    func deleteReply(index: Int) {
        Log.d("index \(index)")
    }
}

extension PrayReplyDetailVM {
    struct Input {
        var orderByDate: Driver<Void> = .empty()
        var orderByName: Driver<Void> = .empty()
    }
    
    struct Output {
        let itemList: Driver<[ReplyItem]>
        let isDateSorted: Driver<Bool>
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
        
        return Output(itemList: itemList.asDriver(),
                      isDateSorted: isDateSorted.asDriver())
    }
}

extension PrayReplyDetailVM {
    struct ReplyItem {
        let memberID: String
        let name: String
        let reply: String
        let date: String
        let isHeader: Bool
        
        init(memberID: String,
             name: String,
             reply: String,
             date: String,
             isHeader: Bool = false
        ) {
            self.memberID = memberID
            self.name = name
            self.reply = reply
            self.date = date
            self.isHeader = isHeader
        }
    }
}
