//
//  GroupPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import RxSwift
import RxCocoa

class GroupPrayVM: VMType {
    typealias PrayItem = CommunityMainVM.GroupIndividualPrayItem
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    
    let cardPrayItemList = BehaviorRelay<[PrayItem]>(value: [])
    
    init(useCase: CommunityMainUseCase) {
        self.useCase = useCase
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.cardMemberPrayList
            .map { list in
                var itemList = [PrayItem]()
                list.forEach { item in
                    itemList.append(PrayItem(name: item.member.name,
                                             pray: item.pray.pray,
                                             date: item.pray.date,
                                             prayID: item.pray.id,
                                             tags: item.pray.tags))
                }
                return itemList
            }
            .bind(to: cardPrayItemList)
            .disposed(by: disposeBag)
    }
}

extension GroupPrayVM {
    struct Input {
        let selectMember: Driver<IndexPath>
    }

    struct Output {
        let cardPrayItemList: Driver<[PrayItem]>
    }

    func transform(input: Input) -> Output {
        return Output(cardPrayItemList: cardPrayItemList.asDriver())
    }
}
