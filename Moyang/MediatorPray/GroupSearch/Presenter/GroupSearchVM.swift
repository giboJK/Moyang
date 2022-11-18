//
//  GroupSearchVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/18.
//

import RxSwift
import RxCocoa

class GroupSearchVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: GroupUseCase
    
    // MARK: - Property
    var selectedGroupIndex = -1
    
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Data
    let groupList = BehaviorRelay<[SearchedGroupItem]>(value: [])
    
    // MARK: - Event
    let requestConfirm = BehaviorRelay<Void>(value: ())
    
    init(useCase: GroupUseCase) {
        self.useCase = useCase
        fetchGroupList()
        bind()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        
    }
    
    private func fetchGroupList() {
        
    }
    
    private func selectGroup() {
        requestConfirm.accept(())
    }
    
    private func confirmGroupRequest() {
        if selectedGroupIndex < 0 { return }
//        uesCase.
    }
}

extension GroupSearchVM {
    struct Input {
        var selectItem: Driver<Int> = .empty()
        var requestJoin: Driver<Void> = .empty()
    }
    
    struct Output {
        let isNetworking: Driver<Bool>
        let groupList: Driver<[SearchedGroupItem]>
        let requestConfirm: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        input.selectItem
            .drive(onNext: { [weak self] index in
                if index < 0 {
                    self?.selectedGroupIndex = -1
                    Log.e("Invalid index")
                    return
                }
                self?.selectGroup()
            }).disposed(by: disposeBag)
        
        input.requestJoin
            .drive(onNext: { [weak self] _ in
                self?.confirmGroupRequest()
            }).disposed(by: disposeBag)
        
        return Output(isNetworking: isNetworking.asDriver(),
                      groupList: groupList.asDriver(),
                      requestConfirm: requestConfirm.asDriver()
        )
    }
}

extension GroupSearchVM {
    struct SearchedGroupItem {
        let name: String
        let desc: String
        let leader: String
        
        init(name: String,
             desc: String,
             leader: String
        ) {
            self.name = name
            self.desc = desc
            self.leader = leader
        }
    }
}
