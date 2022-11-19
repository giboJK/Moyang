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
    let selectedGroupInfo = BehaviorRelay<String>(value: "")
    
    // MARK: - Event
    let requestConfirm = BehaviorRelay<Void>(value: ())
    
    init(useCase: GroupUseCase) {
        self.useCase = useCase
        fetchGroupList()
        bind()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        useCase.searchedGroupList.map { data in
            return data.map { SearchedGroupItem(data: $0) }}
        .bind(to: groupList)
        .disposed(by: disposeBag)
        
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
    }
    
    private func fetchGroupList() {
        useCase.fetchInitialGroupList()
    }
    
    private func selectGroup(index: Int) {
        selectedGroupIndex = index
        if selectedGroupIndex < 0 {
            Log.e("Invalid index")
            return
        }
        requestConfirm.accept(())
        let group = groupList.value[selectedGroupIndex]
        selectedGroupInfo.accept("정말 \(group.name)에 입장을 요청하시겠어요?")
    }
    
    private func confirmGroupRequest() {
        if selectedGroupIndex < 0 { return }
//        uesCase.
    }
    
    func fetchMoreGroupList() {
        useCase.fetchMoreGroupList()
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
        let selectedGroupInfo: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        input.selectItem
            .drive(onNext: { [weak self] index in
                self?.selectGroup(index: index)
            }).disposed(by: disposeBag)
        
        input.requestJoin
            .drive(onNext: { [weak self] _ in
                
                self?.confirmGroupRequest()
            }).disposed(by: disposeBag)
        
        return Output(isNetworking: isNetworking.asDriver(),
                      groupList: groupList.asDriver(),
                      requestConfirm: requestConfirm.asDriver(),
                      selectedGroupInfo: selectedGroupInfo.asDriver()
        )
    }
}

extension GroupSearchVM {
    struct SearchedGroupItem {
        let name: String
        let desc: String
        let leader: String
        
        init(data: GroupSearchedInfo) {
            self.name = data.name
            self.desc = data.desc
            self.leader = "리더: " + data.leader
        }
    }
}
