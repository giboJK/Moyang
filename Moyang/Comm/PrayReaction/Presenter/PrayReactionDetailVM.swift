//
//  PrayReactionDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/07/01.
//

import RxSwift
import RxCocoa

class PrayReactionDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    private let reactions: [PrayReaction]
    let reactionItemList = BehaviorRelay<[ReactionItem]>(value: [])
    
    init(reactions: [PrayReaction]) {
        self.reactions = reactions
        setData()
    }

    deinit { Log.i(self) }
    
    private func setData() {
        var itemList = [ReactionItem]()
        let sorted = reactions.sorted { a, b in
            let typeA = PrayReactionType(rawValue: a.type)!
            let typeB = PrayReactionType(rawValue: b.type)!
            return typeA.order < typeB.order
        }
        var loveItem = ReactionItem(memberName: [], reaction: PrayReactionType.love.rawValue)
        var joyfulItem = ReactionItem(memberName: [], reaction: PrayReactionType.joyful.rawValue)
        var sadItem = ReactionItem(memberName: [], reaction: PrayReactionType.sad.rawValue)
        var prayItem = ReactionItem(memberName: [], reaction: PrayReactionType.prayWithYou.rawValue)
//        sorted.forEach { item in
//            if let type = PrayReactionType(rawValue: item.reaction) {
//                guard let member = groupInfo.memberList.first(where: { $0.id == item.userID }) else { Log.e("No member"); return }
//                switch type {
//                case .love:
//                    loveItem.memberName.append(member.name)
//                case .joyful:
//                    joyfulItem.memberName.append(member.name)
//                case .sad:
//                    sadItem.memberName.append(member.name)
//                case .prayWithYou:
//                    prayItem.memberName.append(member.name)
//                }
//            }
//        }
        if !loveItem.memberName.isEmpty {
            itemList.append(loveItem)
        }
        if !joyfulItem.memberName.isEmpty {
            itemList.append(joyfulItem)
        }
        if !sadItem.memberName.isEmpty {
            itemList.append(sadItem)
        }
        if !prayItem.memberName.isEmpty {
            itemList.append(prayItem)
        }
        reactionItemList.accept(itemList)
    }
}

extension PrayReactionDetailVM {
    struct Input {
    }

    struct Output {
        let reactionItemList: Driver<[ReactionItem]>
    }

    func transform(input: Input) -> Output {
        return Output(reactionItemList: reactionItemList.asDriver())
    }
}

extension PrayReactionDetailVM {
    struct ReactionItem {
        var memberName: [String]
        let reaction: Int
        
        init(memberName: [String],
             reaction: Int
        ) {
            self.memberName = memberName
            self.reaction = reaction
        }
    }
}
