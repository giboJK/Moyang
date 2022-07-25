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
    
    let isEmptyGroup = BehaviorRelay<Bool>(value: true)
    
    private var groupInfo: GroupInfo?
    
    init(useCase: CommunityMainUseCase) {
        self.useCase = useCase
        fetchGroupSummary()
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
        
        useCase.groupSummary
            .subscribe(onNext: { [weak self] data in
                guard let data = data else { return }
                guard let self = self else { return }
                Log.d(data)
                self.isEmptyGroup.accept(false)
                var cardList = [GroupIndividualPrayItem]()
                data.prays.forEach { item in
                    cardList.append(GroupIndividualPrayItem(memberID: item.userID,
                                                            name: item.userName,
                                                            prayID: item.prayID,
                                                            pray: item.content,
                                                            latestDate: item.latestDate,
                                                            isSecret: item.isSecret,
                                                            createDate: item.createDate))
                }
                self.cardPrayItemList.accept(cardList)
            }).disposed(by: disposeBag)
    }
    
    private func fetchGroupSummary() {
        useCase.fetchGroupSummary()
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
        let isEmptyGroup: Driver<Bool>
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
                      groupPrayVM: groupPrayVM.asDriver(),
                      isEmptyGroup: isEmptyGroup.asDriver())
    }
    
    struct GroupIndividualPrayItem {
        let memberID: String
        let name: String
        let pray: String?
        let latestDate: String?
        let prayID: String?
        let isSecret: Bool?
        let createDate: String?
        
        init(memberID: String,
             name: String,
             prayID: String?,
             pray: String?,
             latestDate: String?,
             isSecret: Bool?,
             createDate: String?
        ) {
            self.memberID = memberID
            self.name = name
            self.prayID = prayID
            self.pray = pray
            self.latestDate = latestDate
            self.isSecret = isSecret
            self.createDate = createDate
        }
    }
}
