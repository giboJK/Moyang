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
    
    // MARK: - Data
    let itemList = BehaviorRelay<([String], [[PrayListItem]])>(value: ([], []))
    let userName = BehaviorRelay<String>(value: "")
    
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
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.memberPrayList
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                guard !list.isEmpty else { return }
                var itemList = [[PrayListItem]]()
                let flatList = list.map { PrayListItem(data: $0) }
                var curSection = flatList.first!.latestDate.isoToDateString("yyyy년 M월")
                var curList = [PrayListItem]()
                var sections = [curSection!]
                for item in flatList {
                    if curSection == item.latestDate.isoToDateString("yyyy년 M월") {
                        curList.append(item)
                    } else {
                        itemList.append(curList)
                        curList = [PrayListItem]()
                        curList.append(item)
                        curSection = item.latestDate.isoToDateString("yyyy년 M월")
                        sections.append(curSection!)
                    }
                }
                itemList.append(curList)
                
                self.itemList.accept((sections, itemList))
            }).disposed(by: disposeBag)
        
        useCase.groupDetail
            .subscribe(onNext: { [weak self] detail in
                guard let detail = detail, let self = self else { return }
                if let member = detail.members.first(where: { $0.userID == self.userID }) {
                    self.userName.accept(member.userName)
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchList() {
        useCase.fetchInitialMemberPrayList(groupID: groupID, userID: userID)
    }
    
    private func fetchPrayDetail(index: IndexPath) {
        let prayID = itemList.value.1[index.section][index.row].prayID
        useCase.fetchPrayDetail(prayID: prayID)
    }
    
    func fetchMoreList() {
        useCase.fetchMoreMemberPrayList(groupID: groupID, userID: userID)
    }
    
    private func createDetailVM() {
        detailVM.accept(GroupMemberPrayDetailVM(useCase: useCase))
    }
    
    private func clearList() {
        useCase.clearMemberPray()
    }
}

extension GroupMemberPrayListVM {
    struct Input {
        let selectItem: Driver<IndexPath>
        let clearList: Driver<Void>
    }

    struct Output {
        let isNetworking: Driver<Bool>
        let itemList: Driver<([String], [[PrayListItem]])>
        let userName: Driver<String>
        let detailVM: Driver<GroupMemberPrayDetailVM?>
    }

    func transform(input: Input) -> Output {
        input.selectItem
            .drive(onNext: { [weak self] index in
                self?.fetchPrayDetail(index: index)
                self?.createDetailVM()
            }).disposed(by: disposeBag)
        
        input.clearList
            .drive(onNext: { [weak self] _ in
                self?.clearList()
            }).disposed(by: disposeBag)
        
        return Output(isNetworking: isNetworking.asDriver(),
                      itemList: itemList.asDriver(),
                      userName: userName.asDriver(),
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
                
        init(data: GroupMemberPray) {
            self.prayID = data.prayID
            self.title = data.category
            self.content = data.content
            self.latestDate = data.latestDate
            self.createDate = data.createDate
        }
    }
}
