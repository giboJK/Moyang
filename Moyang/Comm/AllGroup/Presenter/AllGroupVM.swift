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

    let itemList = BehaviorRelay<[GroupInfoItem]>(value: [])
    let groupActivityVM = BehaviorRelay<GroupActivityVM?>(value: nil)
    
    private var groupInfoList = [GroupInfo]()
    
    init(useCase: GroupUseCase) {
        self.useCase = useCase
        bind()
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
}

extension AllGroupVM {
    struct Input {
        let clearList: Driver<Void>
        let selectGroup: Driver<IndexPath>
    }

    struct Output {
        let itemList: Driver<[GroupInfoItem]>
        let groupActivityVM: Driver<GroupActivityVM?>
    }

    func transform(input: Input) -> Output {
        return Output(itemList: itemList.asDriver(),
                      groupActivityVM: groupActivityVM.asDriver())
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
