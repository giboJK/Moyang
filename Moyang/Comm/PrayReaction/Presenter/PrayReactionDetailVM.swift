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
        let memberName: [String]
        let reaction: String
        let count: Int
        
        init(memberName: [String],
             reaction: String,
             count: Int
        ) {
            self.memberName = memberName
            self.reaction = reaction
            self.count = count
        }
    }
}
