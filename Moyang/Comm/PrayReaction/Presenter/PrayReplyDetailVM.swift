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
    let itemList = BehaviorRelay<[ReplyItem]>(value: [])
    let isDateSorted = BehaviorRelay<Bool>(value: true)
    
    init(replys: [PrayReply]) {
        self.replys = replys.sorted(by: { $0.createDate > $1.createDate })
        setData()
    }
    
    deinit { Log.i(self) }
    
    private func setData() {
//        guard let groupInfo = UserData.shared.groupInfo else { return }
//        var itemList = [ReplyItem]()
//        replys.forEach { reply in
//            if let member = groupInfo.memberList.first(where: { $0.id == reply.memberID }) {
//                itemList.append(ReplyItem(memberID: reply.memberID,
//                                          name: member.name,
//                                          reply: reply.reply,
//                                          date: reply.date,
//                                          reactions: reply.reactions,
//                                          order: reply.order))
//            }
//        }
//        self.itemList.accept(itemList)
    }
    
    private func sortByLatest() {
        
    }
    
    private func sortByOldest() {
        
    }
    
    private func sortByName() {
        
    }
}

extension PrayReplyDetailVM {
    struct Input {
        let orderByDate: Driver<Void>
        let orderByName: Driver<Void>
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
        var reactions: [PrayReaction]
        let order: Int
        let isHeader: Bool
        
        init(memberID: String,
             name: String,
             reply: String,
             date: String,
             reactions: [PrayReaction],
             order: Int,
             isHeader: Bool = false
        ) {
            self.memberID = memberID
            self.name = name
            self.reply = reply
            self.date = date
            self.reactions = reactions
            self.order = order
            self.isHeader = isHeader
        }
    }
}
