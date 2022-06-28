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
    let reactionSuccess = BehaviorRelay<Void>(value: ())
    let editVM = BehaviorRelay<GroupPrayEditVM?>(value: nil)

    init(groupID: String, prayItem: PrayItem, useCase: CommunityMainUseCase) {
        self.groupID = groupID
        self.useCase = useCase
        self.auth = prayItem.memberAuth
        self.email = prayItem.memberEmail
        setInitialData(data: prayItem)
        bind()
        fetchPrayList()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.releasePrayingVM),
                                               name: NSNotification.Name(rawValue: "PRAYING_STOP"),
                                               object: nil)
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
                                                 tags: pray.tags,
                                                 isSecret: pray.isSecret,
                                                 isRequestPray: pray.isRequestPray,
                                                 reactions: pray.reactions
                                                ))
                    }
                }
                return itemList
            }
            .bind(to: prayList)
            .disposed(by: disposeBag)
        
        useCase.reactionSuccess
            .skip(1)
            .bind(to: reactionSuccess)
            .disposed(by: disposeBag)
    }
    
    private func setInitialData(data: PrayItem) {
        name.accept(data.name)
    }
    
    private func fetchPrayList(date: String = Date().addingTimeInterval(3600 * 24).toString("yyyy-MM-dd hh:mm:ss a")) {
        if UserData.shared.myInfo?.authType == auth && UserData.shared.myInfo?.email == email {
            useCase.fetchMemberIndividualPray(memberAuth: auth, email: email, groupID: groupID, limit: 5, start: date)
        } else {
            useCase.fetchMemberNonSecretIndividualPray(memberAuth: auth, email: email, groupID: groupID, limit: 5, start: date)
        }
    }
    
    func fetchMorePrayList() {
        if let date = prayList.value.last?.date {
            fetchPrayList(date: date)
        }
    }
    
    func clearPrayList() {
        useCase.clearPrayList()
    }
    
    private func addReaction(index: Int, reaction: PrayReactionType) {
        guard let myInfo = UserData.shared.myInfo else {
            Log.e("")
            return
        }
        let prayID = prayList.value[index].prayID
        
        useCase.addReaction(memberAuth: auth,
                            email: email,
                            prayID: prayID,
                            myInfo: myInfo,
                            reaction: reaction.rawValue,
                            reactions: prayList.value[index].reactions
        )
    }
    
    @objc func releasePrayingVM() {
        groupPrayingVM.accept(nil)
    }
    
    private func setGroupPrayEditVM(index: Int) {
        guard let myInfo = UserData.shared.myInfo else { return }
        if myInfo.email == email && myInfo.authType == auth {
            let prayIrem = prayList.value[index]
            editVM.accept(GroupPrayEditVM(prayItem: prayIrem,
                                          useCase: useCase))
        }
    }
}

extension GroupPrayListVM {
    struct Input {
        let letsPraying: Driver<Void>
        let selectPray: Driver<IndexPath>
        let addLove: Driver<Int?>
        let addJoyful: Driver<Int?>
        let addSad: Driver<Int?>
        let addPray: Driver<Int?>
        let addComment: Driver<Int?>
    }

    struct Output {
        let name: Driver<String>
        let prayList: Driver<[PrayItem]>
        let groupPrayingVM: Driver<GroupPrayingVM?>
        let reactionSuccess: Driver<Void>
        let editVM: Driver<GroupPrayEditVM?>
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
        
        input.selectPray
            .drive(onNext: { [weak self] index in
                self?.setGroupPrayEditVM(index: index.row)
            }).disposed(by: disposeBag)
        
        input.addLove
            .drive(onNext: { [weak self] index in
                guard let self = self, let index = index else {
                    Log.e("")
                    return
                }
                self.addReaction(index: index, reaction: .love)
            }).disposed(by: disposeBag)
        
        input.addJoyful
            .drive(onNext: { [weak self] index in
                guard let self = self, let index = index else {
                    Log.e("")
                    return
                }
                self.addReaction(index: index, reaction: .joyful)
            }).disposed(by: disposeBag)
        
        input.addSad
            .drive(onNext: { [weak self] index in
                guard let self = self, let index = index else {
                    Log.e("")
                    return
                }
                self.addReaction(index: index, reaction: .sad)
            }).disposed(by: disposeBag)
        
        input.addPray
            .drive(onNext: { [weak self] index in
                guard let self = self, let index = index else {
                    Log.e("")
                    return
                }
                self.addReaction(index: index, reaction: .prayWithYou)
            }).disposed(by: disposeBag)
        
        input.addComment
            .drive(onNext: { [weak self] index in
                guard let self = self, let index = index else {
                    Log.e("")
                    return
                }
                self.addReaction(index: index, reaction: .love)
            }).disposed(by: disposeBag)
        
        return Output(name: name.asDriver(),
                      prayList: prayList.asDriver(),
                      groupPrayingVM: groupPrayingVM.asDriver(),
                      reactionSuccess: reactionSuccess.asDriver(),
                      editVM: editVM.asDriver()
        )
    }
}
