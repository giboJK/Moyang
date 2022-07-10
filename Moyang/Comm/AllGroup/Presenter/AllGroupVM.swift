//
//  AllGroupVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//

import RxSwift
import RxCocoa

class AllGroupVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: AllGroupUseCase
    let communityUseCase: CommunityMainUseCase

    let itemList = BehaviorRelay<[GroupInfoItem]>(value: [])
    let groupPrayVM = BehaviorRelay<GroupPrayVM?>(value: nil)
    
    private var groupInfoList = [GroupInfo]()
    
    init(useCase: AllGroupUseCase, communityUseCase: CommunityMainUseCase) {
        self.useCase = useCase
        self.communityUseCase = communityUseCase
        bind()
        fetchGroupList()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.groupInfoList.map { list in list.map { GroupInfoItem(groupInfo: $0) } }
            .bind(to: itemList)
            .disposed(by: disposeBag)
        
        useCase.groupInfoList
            .subscribe(onNext: { [weak self] list in
                self?.groupInfoList = list
            }).disposed(by: disposeBag)
    }
    private func fetchGroupList() {
        useCase.fetchGroupList()
    }
    private func selectGroup(indexPath: IndexPath) {
        if groupInfoList.count < indexPath.row {
            return
        }
        UserData.shared.groupInfo = groupInfoList[indexPath.row]
        let memberList = groupInfoList[indexPath.row].memberList
        memberList.forEach { member in
            communityUseCase.fetchMemberNonSecretIndividualPray(member: member,
                                                       groupID: groupInfoList[indexPath.row].id,
                                                       limit: 1,
                                                       start: Date().addingTimeInterval(3600 * 24).toString("yyyy-MM-dd hh:mm:ss a"))
        }
        groupPrayVM.accept(GroupPrayVM(useCase: communityUseCase, groupID: groupInfoList[indexPath.row].id))
    }
    
    private func clearPrayList() {
        communityUseCase.clearCardMemberPrayList()
    }
}

extension AllGroupVM {
    struct Input {
        let clearList: Driver<Void>
        let selectGroup: Driver<IndexPath>
    }

    struct Output {
        let itemList: Driver<[GroupInfoItem]>
        let groupPrayVM: Driver<GroupPrayVM?>
    }

    func transform(input: Input) -> Output {
        input.clearList
            .drive(onNext: { [weak self] in
                self?.clearPrayList()
            }).disposed(by: disposeBag)
        input.selectGroup
            .drive(onNext: { [weak self] indexPath in
                self?.selectGroup(indexPath: indexPath)
            }).disposed(by: disposeBag)
        
        return Output(itemList: itemList.asDriver(),
                      groupPrayVM: groupPrayVM.asDriver())
    }
}

extension AllGroupVM {
    struct GroupInfoItem {
        let id: String
        let createdDate: String
        let groupName: String
        let parentGroup: String
        let leaderList: [Member]
        let memberList: [Member]
        let pastorInCharge: Member?
        
        init(groupInfo: GroupInfo) {
            self.id = groupInfo.id
            self.createdDate = groupInfo.createdDate
            self.groupName = groupInfo.groupName
            self.parentGroup = groupInfo.parentGroup
            self.leaderList = groupInfo.leaderList
            self.memberList = groupInfo.memberList
            self.pastorInCharge = groupInfo.pastorInCharge
        }
    }
}
