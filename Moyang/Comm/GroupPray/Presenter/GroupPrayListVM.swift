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
                list.forEach { item in
                    itemList.append(PrayItem(memberID: "",
                                             memberAuth: self.auth,
                                             memberEmail: self.email,
                                             name: self.name.value,
                                             pray: item.pray,
                                             date: item.date,
                                             prayID: item.id,
                                             tags: item.tags))
                }
                return itemList
            }
            .bind(to: prayList)
            .disposed(by: disposeBag)
    }
    
    private func setInitialData(data: PrayItem) {
        name.accept(data.name)
    }
    
    private func fetchPrayList(date: String = Date().toString("yyyy-MM-dd hh:mm:ss a")) {
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

    }

    struct Output {
        let name: Driver<String>
        let prayList: Driver<[PrayItem]>
    }

    func transform(input: Input) -> Output {
        return Output(name: name.asDriver(),
                      prayList: prayList.asDriver())
    }
}
