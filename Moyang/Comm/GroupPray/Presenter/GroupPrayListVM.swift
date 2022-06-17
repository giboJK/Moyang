//
//  GroupPrayListVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import RxSwift
import RxCocoa

class GroupPrayListVM: VMType {
    typealias PrayItem = CommunityMainVM.GroupIndividualPrayItem
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    let groupID: String
    let auth: String
    let email: String
    
    let name = BehaviorRelay<String>(value: "")
    let prayList = BehaviorRelay<[PrayItem]>(value: [])
    let isNetworking = BehaviorRelay<Bool>(value: false)
    let groupPrayingVM = BehaviorRelay<GroupPrayingVM?>(value: nil)

    init(groupID: String, prayItem: PrayItem, useCase: CommunityMainUseCase) {
        self.groupID = groupID
        self.useCase = useCase
        self.auth = prayItem.memberAuth
        self.email = prayItem.memberEmail
        setInitialData(data: prayItem)
        bind()
        fetchPrayList()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.memberPrayList
            .map { [weak self] list in
                guard let self = self else { return [] }
                var itemList = [PrayItem]()
                list.filter { $0.member.auth == self.auth && $0.member.email == self.email}.forEach { item in
                    item.list.forEach { pray in
                        itemList.append(PrayItem(memberID: item.member.id,
                                                 memberAuth: self.auth,
                                                 memberEmail: self.email,
                                                 name: item.member.name,
                                                 pray: pray.pray,
                                                 date: pray.date,
                                                 prayID: pray.id,
                                                 tags: pray.tags))
                    }
                }
                return itemList
            }
            .bind(to: prayList)
            .disposed(by: disposeBag)
    }
    
    private func setInitialData(data: PrayItem) {
        name.accept(data.name)
    }
    
    private func fetchPrayList(date: String = Date().addingTimeInterval(3600 * 24).toString("yyyy-MM-dd hh:mm:ss a")) {
        useCase.fetchMemberIndividualPray(memberAuth: auth, email: email, groupID: groupID, limit: 10, start: date)
    }
    
    func fetchMorePrayList() {
        if let date = prayList.value.last?.date {
            fetchPrayList(date: date)
        }
    }
    
    func clearPrayList() {
        useCase.clearPrayList()
    }
}

extension GroupPrayListVM {
    struct Input {
        let letsPraying: Driver<Void>
    }

    struct Output {
        let name: Driver<String>
        let prayList: Driver<[PrayItem]>
        let groupPrayingVM: Driver<GroupPrayingVM?>
    }

    func transform(input: Input) -> Output {
        input.letsPraying
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vm = GroupPrayingVM(useCase: self.useCase,
                                        auth: self.auth,
                                        email: self.email,
                                        groupID: self.groupID)
                self.groupPrayingVM.accept(vm)
            }).disposed(by: disposeBag)
        
        return Output(name: name.asDriver(),
                      prayList: prayList.asDriver(),
                      groupPrayingVM: groupPrayingVM.asDriver())
    }
}
