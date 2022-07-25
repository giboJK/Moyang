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
    
    let name = BehaviorRelay<String>(value: "")
    let prayList = BehaviorRelay<[PrayItem]>(value: [])
    let isNetworking = BehaviorRelay<Bool>(value: false)
    let groupPrayingVM = BehaviorRelay<GroupPrayingVM?>(value: nil)
    let reactionSuccess = BehaviorRelay<Void>(value: ())
    let editVM = BehaviorRelay<GroupPrayEditVM?>(value: nil)
    let prayReactionDetailVM = BehaviorRelay<PrayReactionDetailVM?>(value: nil)
    let prayReplyDetailVM = BehaviorRelay<PrayReplyDetailVM?>(value: nil)
    let prayWithAndChangeVM = BehaviorRelay<PrayWithAndChangeVM?>(value: nil)
    let isMyPrayList = BehaviorRelay<Bool>(value: false)

    init(groupID: String, prayItem: PrayItem, useCase: CommunityMainUseCase) {
        self.groupID = groupID
        self.useCase = useCase
        setInitialData(data: prayItem)
        bind()
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(100)) {
            if self.prayList.value.isEmpty {
                self.fetchPrayList()
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.releasePrayingVM),
                                               name: NSNotification.Name(rawValue: "PRAYING_STOP"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setReactionVM),
                                               name: NSNotification.Name(rawValue: "GROUP_PRAY_REACTION_TAP"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setReplyVM),
                                               name: NSNotification.Name(rawValue: "GROUP_PRAY_REPLY_TAP"),
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
                return self.convertToItemList(data: list)
            }
            .bind(to: prayList)
            .disposed(by: disposeBag)
        
        useCase.reactionSuccess
            .skip(1)
            .bind(to: reactionSuccess)
            .disposed(by: disposeBag)
    }
    
    private func convertToItemList(data: [(member: Member, list: [GroupIndividualPray])]) -> [GroupPrayListVM.PrayItem] {
        return []
    }
    
    private func setInitialData(data: PrayItem) {
        name.accept(data.name)
        guard let myInfo = UserData.shared.myInfo else { return }
        if myInfo.id == data.memberID {
            isMyPrayList.accept(true)
        } else {
            isMyPrayList.accept(false)
        }
    }
    
    private func fetchPrayList(date: String = Date().addingTimeInterval(3600 * 24).toString("yyyy-MM-dd hh:mm:ss a")) {
//        if UserData.shared.myInfo?.authType == auth && UserData.shared.myInfo?.email == email {
//            useCase.fetchMemberIndividualPray(memberAuth: auth, email: email, groupID: groupID, limit: 5, start: date)
//        } else {
//            useCase.fetchMemberNonSecretIndividualPray(memberAuth: auth, email: email, groupID: groupID, limit: 5, start: date)
//        }
    }
    
    func fetchMorePrayList() {
//        if let date = prayList.value.last?.date {
//            fetchPrayList(date: date)
//        }
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
        
    }
    
    @objc func releasePrayingVM() {
        groupPrayingVM.accept(nil)
    }
    
    @objc func setReactionVM(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            Log.e(""); return
        }
//        let reactions = prayList.value[index].reactions
//        prayReactionDetailVM.accept(PrayReactionDetailVM(reactions: reactions))
    }
    
    @objc func setReplyVM(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            Log.e(""); return
        }
//        let replys = prayList.value[index].replys
//        prayReplyDetailVM.accept(PrayReplyDetailVM(replys: replys))
    }
    
    private func setGroupPrayEditVM(index: Int) {
        guard let myInfo = UserData.shared.myInfo else { return }
        
//        let prayIrem = prayList.value[index]
//        editVM.accept(GroupPrayEditVM(prayItem: prayIrem,
//                                      isMyPray: (myInfo.email == email && myInfo.authType == auth),
//                                      useCase: useCase))
    }
    
    private func setPrayWithAndChangeVM(index: Int) {
        let prayIrem = prayList.value[index]
        prayWithAndChangeVM.accept(PrayWithAndChangeVM(useCase: useCase, prayItme: prayIrem))
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
        let addChange: Driver<Int?>
    }

    struct Output {
        let name: Driver<String>
        let prayList: Driver<[PrayItem]>
        let groupPrayingVM: Driver<GroupPrayingVM?>
        let reactionSuccess: Driver<Void>
        let editVM: Driver<GroupPrayEditVM?>
        let prayReactionDetailVM: Driver<PrayReactionDetailVM?>
        let prayReplyDetailVM: Driver<PrayReplyDetailVM?>
        let prayWithAndChangeVM: Driver<PrayWithAndChangeVM?>
        let isMyPrayList: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        input.letsPraying
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vm = GroupPrayingVM(useCase: self.useCase,
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
                self.setPrayWithAndChangeVM(index: index)
            }).disposed(by: disposeBag)
        
        input.addChange
            .drive(onNext: { [weak self] index in
                guard let self = self, let index = index else {
                    Log.e("")
                    return
                }
                self.setPrayWithAndChangeVM(index: index)
            }).disposed(by: disposeBag)
        
        return Output(name: name.asDriver(),
                      prayList: prayList.asDriver(),
                      groupPrayingVM: groupPrayingVM.asDriver(),
                      reactionSuccess: reactionSuccess.asDriver(),
                      editVM: editVM.asDriver(),
                      prayReactionDetailVM: prayReactionDetailVM.asDriver(),
                      prayReplyDetailVM: prayReplyDetailVM.asDriver(),
                      prayWithAndChangeVM: prayWithAndChangeVM.asDriver(),
                      isMyPrayList: isMyPrayList.asDriver()
        )
    }
}
