//
//  GroupPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import RxSwift
import RxCocoa

class GroupPrayVM: VMType {
    typealias PrayItem = CommunityMainVM.GroupIndividualPrayItem
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    let groupID: String
    
    let cardPrayItemList = BehaviorRelay<[PrayItem]>(value: [])
    let detailVM = BehaviorRelay<GroupPrayListVM?>(value: nil)
    
    let newPray = BehaviorRelay<String?>(value: nil)
    let newTag = BehaviorRelay<String?>(value: nil)
    let tagList = BehaviorRelay<[String]>(value: [])
    
    let addingNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addingNewPrayFailure = BehaviorRelay<Void>(value: ())
    
    let isSecret = BehaviorRelay<Bool>(value: false)
    let isRequestPray = BehaviorRelay<Bool>(value: false)
    
    let prayReactionDetailVM = BehaviorRelay<PrayReactionDetailVM?>(value: nil)
    let prayReplyDetailVM = BehaviorRelay<PrayReplyDetailVM?>(value: nil)
    
    init(useCase: CommunityMainUseCase, groupID: String) {
        self.useCase = useCase
        self.groupID = groupID
        bind()
        
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
        useCase.cardMemberPrayList
            .map { list in
                var itemList = [PrayItem]()
                list.forEach { item in
                    itemList.append(PrayItem(memberID: item.member.id,
                                             memberAuth: item.member.auth,
                                             memberEmail: item.member.email,
                                             name: item.member.name,
                                             pray: item.pray.pray,
                                             date: item.pray.date,
                                             prayID: item.pray.id,
                                             tags: item.pray.tags,
                                             isSecret: item.pray.isSecret,
                                             isRequestPray: item.pray.isRequestPray,
                                             reactions: item.pray.reactions,
                                             replys: item.pray.replys
                                            ))
                }
                return itemList
            }
            .bind(to: cardPrayItemList)
            .disposed(by: disposeBag)
        
        useCase.addingNewPraySuccess
            .bind(to: addingNewPraySuccess)
            .disposed(by: disposeBag)
        
        useCase.addingNewPraySuccess
            .skip(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.clearAutoSave()
            }).disposed(by: disposeBag)
        
        useCase.addingNewPrayFailure
            .bind(to: addingNewPrayFailure)
            .disposed(by: disposeBag)
    }
    
    func clearNewTag() {
        tagList.accept([])
    }
    
    private func addNewPray() {
        useCase.addIndividualPray(id: UUID().uuidString,
                                  groupID: groupID,
                                  date: Date().toString("yyyy-MM-dd hh:mm:ss a"),
                                  pray: newPray.value!,
                                  tags: tagList.value,
                                  isSecret: isSecret.value,
                                  isRequestPray: isRequestPray.value
        )
    }
    
    private func autoSave() {
        UserData.shared.autoSavedPray = newPray.value
        UserData.shared.autoSavedTags = tagList.value
    }
    
    private func loadAutoSave() {
        if let autoSavedPray = UserData.shared.autoSavedPray {
            newPray.accept(autoSavedPray)
        }
        if let autoSavedTags = UserData.shared.autoSavedTags {
            tagList.accept(autoSavedTags)
        }
    }
    
    private func clearAutoSave() {
        UserData.shared.clearAutoSave()
    }
    
    @objc func setReactionVM(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            Log.e(""); return
        }
        let reactions = cardPrayItemList.value[index].reactions
        prayReactionDetailVM.accept(PrayReactionDetailVM(reactions: reactions))
    }
    
    @objc func setReplyVM(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            Log.e(""); return
        }
        let replys = cardPrayItemList.value[index].replys
        prayReplyDetailVM.accept(PrayReplyDetailVM(replys: replys))
    }
}

extension GroupPrayVM {
    struct Input {
        var selectMember: Driver<IndexPath> = .empty()
        var setPray: Driver<String?> = .empty()
        var autoSave: Driver<Void> = .empty()
        var saveNewPray: Driver<Void> = .empty()
        var newTag: Driver<String?> = .empty()
        var setTag: Driver<String?> = .empty()
        var addTag: Driver<Void> = .empty()
        var deleteTag: Driver<IndexPath?> = .empty()
        var loadAutoPray: Driver<Bool> = .empty()
        var toggleIsSecret: Driver<Void> = .empty()
        var toggleIsRequestPray: Driver<Void> = .empty()
        var releaseDetailVM: Driver<Void> = .empty()
    }
    
    struct Output {
        let cardPrayItemList: Driver<[PrayItem]>
        let detailVM: Driver<GroupPrayListVM?>
        let newPray: Driver<String?>
        let newTag: Driver<String?>
        let tagList: Driver<[String]>
        let addingNewPraySuccess: Driver<Void>
        let addingNewPrayFailure: Driver<Void>
        let isSecret: Driver<Bool>
        let isRequestPray: Driver<Bool>
        let prayReactionDetailVM: Driver<PrayReactionDetailVM?>
        let prayReplyDetailVM: Driver<PrayReplyDetailVM?>
    }
    
    func transform(input: Input) -> Output {
        input.selectMember
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let detailVM = GroupPrayListVM(groupID: self.groupID,
                                               prayItem: self.cardPrayItemList.value[indexPath.row],
                                               useCase: self.useCase)
                self.detailVM.accept(detailVM)
            }).disposed(by: disposeBag)
        
        input.setPray
            .drive(newPray)
            .disposed(by: disposeBag)
        
        input.setPray
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.autoSave()
            }).disposed(by: disposeBag)
        
        input.saveNewPray
            .drive(onNext: { [weak self] _ in
                self?.addNewPray()
            }).disposed(by: disposeBag)
        
        input.setTag
            .skip(1)
            .drive(onNext: { [weak self] tag in
                guard let tag = tag else { return }
                self?.newTag.accept(String(tag.prefix(20)))
            }).disposed(by: disposeBag)
        
        input.addTag
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                var currnetTags = self.tagList.value
                if let tag = self.newTag.value,
                   !tag.isEmpty, !tag.trimmingCharacters(in: .whitespaces).isEmpty {
                    currnetTags.append(tag)
                    self.tagList.accept(currnetTags)
                    self.newTag.accept(nil)
                    self.autoSave()
                }
            }).disposed(by: disposeBag)
        
        input.deleteTag
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { Log.e(""); return }
                guard let indexPath = indexPath else { Log.e(""); return }
                var currnetTags = self.tagList.value
                if currnetTags.count > indexPath.row {
                    currnetTags.remove(at: indexPath.row)
                    self.tagList.accept(currnetTags)
                    self.autoSave()
                }
            }).disposed(by: disposeBag)
        
        input.loadAutoPray
            .drive(onNext: { [weak self] willBeAppeared in
                if willBeAppeared {
                    self?.loadAutoSave()
                }
            }).disposed(by: disposeBag)
        
        input.toggleIsSecret
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isSecret.accept(!self.isSecret.value)
            }).disposed(by: disposeBag)
        
        input.toggleIsRequestPray
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isRequestPray.accept(!self.isRequestPray.value)
            }).disposed(by: disposeBag)
        
        input.releaseDetailVM
            .drive(onNext: { [weak self] _ in
                self?.detailVM.accept(nil)
            }).disposed(by: disposeBag)
        
        return Output(cardPrayItemList: cardPrayItemList.asDriver(),
                      detailVM: detailVM.asDriver(),
                      newPray: newPray.asDriver(),
                      newTag: newTag.asDriver(),
                      tagList: tagList.asDriver(),
                      addingNewPraySuccess: addingNewPraySuccess.asDriver(),
                      addingNewPrayFailure: addingNewPrayFailure.asDriver(),
                      isSecret: isSecret.asDriver(),
                      isRequestPray: isRequestPray.asDriver(),
                      prayReactionDetailVM: prayReactionDetailVM.asDriver(),
                      prayReplyDetailVM: prayReplyDetailVM.asDriver()
        )
    }
}
