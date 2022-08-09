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
        var loveItem = ReactionItem(name: [], reaction: PrayReactionType.love.rawValue)
        var joyfulItem = ReactionItem(name: [], reaction: PrayReactionType.joyful.rawValue)
        var sadItem = ReactionItem(name: [], reaction: PrayReactionType.sad.rawValue)
        var prayItem = ReactionItem(name: [], reaction: PrayReactionType.prayWithYou.rawValue)
        sorted.forEach { item in
            if let type = PrayReactionType(rawValue: item.type) {
                switch type {
                case .love:
                    loveItem.name.append(item.name)
                case .joyful:
                    joyfulItem.name.append(item.name)
                case .sad:
                    sadItem.name.append(item.name)
                case .prayWithYou:
                    prayItem.name.append(item.name)
                }
            }
        }
        if !loveItem.name.isEmpty {
            itemList.append(loveItem)
        }
        if !joyfulItem.name.isEmpty {
            itemList.append(joyfulItem)
        }
        if !sadItem.name.isEmpty {
            itemList.append(sadItem)
        }
        if !prayItem.name.isEmpty {
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
        var name: [String]
        let reaction: Int
        
        init(name: [String],
             reaction: Int
        ) {
            self.name = name
            self.reaction = reaction
        }
    }
}
