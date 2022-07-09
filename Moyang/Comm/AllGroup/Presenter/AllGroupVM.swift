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
    let useCase: AllGroupUseCase

    let itemList = BehaviorRelay<[GroupInfoItem]>(value: [])
    
    init(useCase: AllGroupUseCase) {
        self.useCase = useCase
        bind()
        fetchGroupList()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.groupInfoList.map { list in list.map { GroupInfoItem(groupInfo: $0) } }
            .bind(to: itemList)
            .disposed(by: disposeBag)
    }
    private func fetchGroupList() {
        useCase.fetchGroupList()
    }
}

extension AllGroupVM {
    struct Input {

    }

    struct Output {
        let itemList: Driver<[GroupInfoItem]>
    }

    func transform(input: Input) -> Output {
        return Output(itemList: itemList.asDriver())
    }
}

extension AllGroupVM {
    struct GroupInfoItem {
        let id: String
        let createdDate: String
        let groupName: String
        let parentGroup: String
        let leaderList: [Member]
        let memberList: [Member]
        let pastorInCharge: String
        
        init(groupInfo: GroupInfo) {
            self.id = groupInfo.id
            self.createdDate = groupInfo.createdDate
            self.groupName = groupInfo.groupName
            self.parentGroup = groupInfo.parentGroup
            self.leaderList = groupInfo.leaderList
            self.memberList = groupInfo.memberList
            self.pastorInCharge = groupInfo.pastorInCharge
        }
    }
}
