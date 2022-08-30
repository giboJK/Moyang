//
//  AllGroupVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import RxSwift
import RxCocoa

class AllGroupVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: GroupUseCase
    let communityUseCase: CommunityMainUseCase

    let itemList = BehaviorRelay<[GroupInfoItem]>(value: [])
    let groupPrayVM = BehaviorRelay<GroupPrayVM?>(value: nil)
    
    private var groupInfoList = [GroupInfo]()
    
    init(useCase: GroupUseCase, communityUseCase: CommunityMainUseCase) {
        self.useCase = useCase
        self.communityUseCase = communityUseCase
        bind()
        fetchGroupList()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.groupInfoList.map { list in list.map { GroupInfoItem(groupInfo: $0) } }
            .bind(to: itemList)
            .disposed(by: disposeBag)
        
        useCase.groupInfoList
            .subscribe(onNext: { [weak self] list in
                self?.groupInfoList = list
            }).disposed(by: disposeBag)
    }
    
    private func fetchGroupList() {
        useCase.fetchGroupList()
    }
    
    private func selectGroup(indexPath: IndexPath) {
//        groupPrayVM.accept(GroupPrayVM(useCase: communityUseCase))
    }
    
}

extension AllGroupVM {
    struct Input {
        let clearList: Driver<Void>
        let selectGroup: Driver<IndexPath>
    }

    struct Output {
        let itemList: Driver<[GroupInfoItem]>
        let groupPrayVM: Driver<GroupPrayVM?>
    }

    func transform(input: Input) -> Output {
        input.selectGroup
            .drive(onNext: { [weak self] indexPath in
                self?.selectGroup(indexPath: indexPath)
            }).disposed(by: disposeBag)
        
        return Output(itemList: itemList.asDriver(),
                      groupPrayVM: groupPrayVM.asDriver())
    }
}

extension AllGroupVM {
    struct GroupInfoItem {
        let id: String
        let createdDate: String
        let groupName: String
        
        init(groupInfo: GroupInfo) {
            self.id = groupInfo.id
            self.createdDate = groupInfo.createDate
            self.groupName = groupInfo.groupName
        }
    }
}
