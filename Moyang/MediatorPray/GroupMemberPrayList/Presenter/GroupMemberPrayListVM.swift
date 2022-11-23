//
//  GroupMemberPrayListVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/23.
//

import RxSwift
import RxCocoa

class GroupMemberPrayListVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: GroupUseCase
    let groupID: String
    let userID: String
    
    // MARK: - Events
    let isNetworking = BehaviorRelay<Bool>(value: false)
    let itemList = BehaviorRelay<([String], [[PrayListItem]])>(value: ([], []))
    
    // MARK: - UI
    
    // MARK: - VM
    let detailVM = BehaviorRelay<GroupMemberPrayDetailVM?>(value: nil)
    
    init(useCase: GroupUseCase, groupID: String, userID: String) {
        self.useCase = useCase
        self.groupID = groupID
        self.userID = userID
        bind()
        fetchList()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        // TODO: - 추후 리프레시 추가
        
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
    }
    
    private func fetchList() {
        useCase.fetchPrayList(groupID: groupID, userID: userID)
    }
    
    private func fetchPrayDetail(index: IndexPath) {
        let prayID = itemList.value.1[index.section][index.row].prayID
        useCase.fetchPrayDetail(prayID: prayID)
    }
    
    private func createDetailVM() {
        detailVM.accept(GroupMemberPrayDetailVM(useCase: useCase))
    }
}

extension GroupMemberPrayListVM {
    struct Input {
        let selectItem: Driver<IndexPath>
    }

    struct Output {
        let isNetworking: Driver<Bool>
        let itemList: Driver<([String], [[PrayListItem]])>
        let detailVM: Driver<GroupMemberPrayDetailVM?>
    }

    func transform(input: Input) -> Output {
        input.selectItem
            .drive(onNext: { [weak self] index in
                self?.fetchPrayDetail(index: index)
            }).disposed(by: disposeBag)
        return Output(isNetworking: isNetworking.asDriver(),
                      itemList: itemList.asDriver(),
                      detailVM: detailVM.asDriver()
        )
    }
}

extension GroupMemberPrayListVM {
    struct PrayListItem {
        // Pray
        let prayID: String
        let title: String
        let content: String
        var latestDate: String
        let createDate: String
                
        init(data: MyPray) {
            self.prayID = data.prayID
            self.title = data.category
            self.content = data.content
            self.latestDate = data.latestDate
            self.createDate = data.createDate
        }
    }
}
