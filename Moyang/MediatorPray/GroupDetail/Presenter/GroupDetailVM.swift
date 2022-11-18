//
//  GroupDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/17.
//

import RxSwift
import RxCocoa

class GroupDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: GroupUseCase
    let groupID: String
    
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Data
    let isLeader = BehaviorRelay<Bool>(value: false)
    let groupName = BehaviorRelay<String>(value: "")
    let desc = BehaviorRelay<String>(value: "")
    let mediatorItemList = BehaviorRelay<[MediatorItem]>(value: [])

    init(useCase: GroupUseCase, groupID: String) {
        self.useCase = useCase
        self.groupID = groupID
        bind()
    }

    deinit { Log.i(self) }

    private func bind() {

    }
}

extension GroupDetailVM {
    struct Input {
        let selectUser: Driver<IndexPath>
    }

    struct Output {
        // MARK: - State
        let isNetworking: Driver<Bool>
        
        // MARK: - Data
        let isLeader: Driver<Bool>
        let groupName: Driver<String>
        let desc: Driver<String>
        let mediatorItemList: Driver<[MediatorItem]>
    }

    func transform(input: Input) -> Output {
        return Output(isNetworking: isNetworking.asDriver(),
                      isLeader: isLeader.asDriver(),
                      groupName: groupName.asDriver(),
                      desc: desc.asDriver(),
                      mediatorItemList: mediatorItemList.asDriver())
    }
}

extension GroupDetailVM {
    struct MediatorItem {
        let name: String
        let category: String
        let date: String
        
        init(name: String, category: String, date: String) {
            self.name = name
            self.category = category
            self.date = date
        }
    }
}
