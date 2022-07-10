//
//  CommunityMainVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import RxSwift
import RxCocoa

class CommunityMainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    
    let groupName = BehaviorRelay<String>(value: "")
    let myPray = BehaviorRelay<GroupIndividualPrayItem?>(value: nil)
    let cardPrayItemList = BehaviorRelay<[GroupIndividualPrayItem]>(value: [])
    let groupPrayVM = BehaviorRelay<GroupPrayVM?>(value: nil)
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    private var groupInfo: GroupInfo?
    
    init(useCase: CommunityMainUseCase) {
        self.useCase = useCase
        fetchGroupInfo()
        bind()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.groupInfo
            .subscribe(onNext: { [weak self] groupInfo in
                guard let groupInfo = groupInfo else { return }
                self?.setGroupInfoData(data: groupInfo)
            }).disposed(by: disposeBag)
        
        useCase.cardMemberPrayList
            .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .map { list in
                guard let myInfo = UserData.shared.myInfo else { return [] }
                var itemList = [GroupIndividualPrayItem]()
                list.filter({ $0.member.id != myInfo.id }).forEach { item in
                    itemList.append(GroupIndividualPrayItem(memberID: item.member.id,
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
                                                            replys: item.pray.replys,
                                                            registeredDate: item.pray.registeredDate
                                                           ))
                }
                return itemList
            }
            .bind(to: cardPrayItemList)
            .disposed(by: disposeBag)
        
        useCase.cardMemberPrayList
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .map { list -> GroupIndividualPrayItem? in
                guard let myInfo = UserData.shared.myInfo else { return nil }
                if let myPray = list.first(where: { $0.member.id == myInfo.id }) {
                    return GroupIndividualPrayItem(memberID: myPray.member.id,
                                                   memberAuth: myPray.member.auth,
                                                   memberEmail: myPray.member.email,
                                                   name: myPray.member.name,
                                                   pray: myPray.pray.pray,
                                                   date: myPray.pray.date,
                                                   prayID: myPray.pray.id,
                                                   tags: myPray.pray.tags,
                                                   isSecret: myPray.pray.isSecret,
                                                   isRequestPray: myPray.pray.isRequestPray,
                                                   reactions: myPray.pray.reactions,
                                                   replys: myPray.pray.replys,
                                                   registeredDate: myPray.pray.registeredDate
                    )
                } else {
                    return nil
                }
            }.bind(to: myPray)
            .disposed(by: disposeBag)
    }
    
    private func fetchGroupInfo() {
        useCase.fetchGroupInfo()
    }
    
    private func setGroupInfoData(data: GroupInfo) {
        groupInfo = data
        groupName.accept(data.groupName)
        getMemberPray(memberList: data.memberList)
        UserData.shared.groupInfo = data
    }
    
    private func getMemberPray(memberList: [Member]) {
        guard let groupInfo = groupInfo else { Log.e("No GroupInfo"); return }
        memberList.forEach { member in
            useCase.fetchMemberNonSecretIndividualPray(member: member,
                                                       groupID: groupInfo.id,
                                                       limit: 1,
                                                       start: Date().addingTimeInterval(3600 * 24).toString("yyyy-MM-dd hh:mm:ss a"))
        }
    }
}

extension CommunityMainVM {
    struct Input {
        var didTapPrayCard: Driver<Void> = .empty()
    }
    
    struct Output {
        let isNetworking: Driver<Bool>
        let groupName: Driver<String>
        let myPray: Driver<GroupIndividualPrayItem?>
        let cardPrayItemList: Driver<[GroupIndividualPrayItem]>
        let groupPrayVM: Driver<GroupPrayVM?>
    }
    
    func transform(input: Input) -> Output {
        input.didTapPrayCard
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let groupID = self.groupInfo?.id else { Log.e(""); return }
                // TODO Fix
                UserData.shared.groupInfo = self.groupInfo
                self.groupPrayVM.accept(GroupPrayVM(useCase: self.useCase, groupID: groupID))
            }).disposed(by: disposeBag)
        
        return Output(isNetworking: isNetworking.asDriver(),
                      groupName: groupName.asDriver(),
                      myPray: myPray.asDriver(),
                      cardPrayItemList: cardPrayItemList.asDriver(),
                      groupPrayVM: groupPrayVM.asDriver())
    }
    
    struct GroupIndividualPrayItem {
        let memberID: String
        let memberAuth: String
        let memberEmail: String
        let name: String
        let pray: String
        let date: String
        let prayID: String
        let tags: [String]
        let isSecret: Bool
        let isRequestPray: Bool
        let reactions: [PrayReaction]
        let replys: [PrayReply]
        let changes: [PrayReply]
        let registeredDate: String
        
        init(memberID: String,
             memberAuth: String,
             memberEmail: String,
             name: String,
             pray: String,
             date: String,
             prayID: String,
             tags: [String],
             isSecret: Bool,
             isRequestPray: Bool,
             reactions: [PrayReaction],
             replys: [PrayReply],
             registeredDate: String
        ) {
            self.memberID = memberID
            self.memberAuth = memberAuth
            self.memberEmail = memberEmail
            self.name = name
            self.pray = pray
            self.date = date
            self.prayID = prayID
            self.tags = tags
            self.isSecret = isSecret
            self.isRequestPray = isRequestPray
            self.reactions = reactions
            self.replys = replys.filter { $0.memberID != memberID }
            self.changes = replys.filter { $0.memberID == memberID }.sorted(by: { $0.date > $1.date })
            self.registeredDate = registeredDate
        }
    }
}
