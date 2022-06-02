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
    let detailVM = BehaviorRelay<GroupPrayListVM?>(value: nil)
    
    let newPray = BehaviorRelay<String?>(value: nil)
    let newTag = BehaviorRelay<String?>(value: nil)
    let tagList = BehaviorRelay<[String]>(value: [])
    
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
                    itemList.append(PrayItem(memberID: item.member.id,
                                             name: item.member.name,
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
        var selectMember: Driver<IndexPath> = .empty()
        var setPray: Driver<String?> = .empty()
        var saveNewPray: Driver<Void> = .empty()
        var setTag: Driver<String?> = .empty()
        var addTag: Driver<Void> = .empty()
        var removeTag: Driver<IndexPath> = .empty()
    }
    
    struct Output {
        let cardPrayItemList: Driver<[PrayItem]>
        let detailVM: Driver<GroupPrayListVM?>
        let newPray: Driver<String?>
        let tagList: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        input.selectMember
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let detailVM = GroupPrayListVM(prayItem: self.cardPrayItemList.value[indexPath.row],
                                                 useCase: self.useCase)
                self.detailVM.accept(detailVM)
            }).disposed(by: disposeBag)
        
        input.setPray
            .drive(newPray)
            .disposed(by: disposeBag)
        
        input.setTag
            .drive(newTag)
            .disposed(by: disposeBag)
        
        input.addTag
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                var currnetTags = self.tagList.value
                if let tag = self.newTag.value {
                    currnetTags.append(tag)
                    self.tagList.accept(currnetTags)
                }
            }).disposed(by: disposeBag)
        
        return Output(cardPrayItemList: cardPrayItemList.asDriver(),
                      detailVM: detailVM.asDriver(),
                      newPray: newPray.asDriver(),
                      tagList: tagList.asDriver())
    }
}
