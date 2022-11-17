//
//  MediatorPrayMainVM.swift
//  Moyang
//
//  Created by kibo on 2022/10/24.
//

import RxSwift
import RxCocoa

class MediatorPrayMainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: GroupUseCase

    private let groupList = BehaviorRelay<[GroupItem]>(value: [])
    init(useCase: GroupUseCase) {
        self.useCase = useCase
        bind()
        fetchGroupList()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchGroupList),
                                               name: NSNotification.Name.ReloadGroupList, object: nil)
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.myGroups
            .map({ list in list.map { GroupItem(data: $0) } })
            .bind(to: groupList)
            .disposed(by: disposeBag)
    }
    
    @objc func fetchGroupList() {
        useCase.fetchMyGroupList()
    }
}

extension MediatorPrayMainVM {
    struct Input { }

    struct Output {
        let groupList: Driver<[GroupItem]>
    }

    func transform(input: Input) -> Output {
        return Output(groupList: groupList.asDriver())
    }
}

extension MediatorPrayMainVM {
    struct GroupItem {
        let id: String
        let name: String
        let desc: String
        let createDate: String
        
        init(data: GroupInfo) {
            id = data.id
            name = data.name
            desc = data.desc
            createDate = data.createDate
        }
    }
}
