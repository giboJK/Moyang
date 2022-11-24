//
//  GroupDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/17.
//

import RxSwift
import RxCocoa

class GroupDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: GroupUseCase
    let groupID: String
    
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Data
    let hasJoinReq = BehaviorRelay<Bool>(value: false)
    let isLeader = BehaviorRelay<Bool>(value: false)
    let groupName = BehaviorRelay<String>(value: "")
    let desc = BehaviorRelay<String>(value: "")
    let mediatorItemList = BehaviorRelay<[MediatorItem]>(value: [])
    let memberList = BehaviorRelay<[MediatorItem]>(value: [])

    // MARK: - VM
    let listVM = BehaviorRelay<GroupMemberPrayListVM?>(value: nil)
    
    // MARK: - Event
    let showExitConfirmPopup = BehaviorRelay<Void>(value: ())
    let exitGroupSuccess = BehaviorRelay<Void>(value: ())
    let exitGroupFailure = BehaviorRelay<Void>(value: ())
    
    
    init(useCase: GroupUseCase, groupID: String) {
        self.useCase = useCase
        self.groupID = groupID
        bind()
        fetchGroupDetail()
    }

    deinit { Log.i(self) }

    private func bind() {
        useCase.myGroupMediatorInfos
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                if let group = list.first(where: { $0.id == self.groupID }) {
                    self.groupName.accept(group.name)
                    self.desc.accept(group.desc)
                }
            }).disposed(by: disposeBag)
        
        useCase.groupDetail
            .subscribe(onNext: { [weak self] detail in
                guard let self = self, let detail = detail else { return }
                guard let myID = UserData.shared.userInfo?.id else { return }
                var itemList = [MediatorItem]()
                for pray in detail.prays {
                    itemList.append(MediatorItem(groupDetailPray: pray))
                }
                itemList.sort { $0.date < $1.date }

                for member in detail.members {
                    if !itemList.contains(where: { $0.userID == member.userID }) {
                        itemList.append(MediatorItem(groupMember: member))
                    } else {
                        
                    }
                    if member.userID == myID {
                        self.isLeader.accept(member.isLeader)
                    }
                }
                
                self.hasJoinReq.accept(!detail.reqs.isEmpty)
                
                self.mediatorItemList.accept(itemList)
            }).disposed(by: disposeBag)
        
        useCase.groupDetail
            .subscribe(onNext: { [weak self] detail in
                guard let self = self, let detail = detail else { return }
                var itemList = [MediatorItem]()
                for member in detail.members {
                    itemList.append(MediatorItem(groupMember: member))
                }
                itemList.sort { leftItem, _ in
                    return leftItem.isLeader
                }
                self.memberList.accept(itemList)
            }).disposed(by: disposeBag)
        
        useCase.exitGroupSuccess
            .bind(to: exitGroupSuccess)
            .disposed(by: disposeBag)
        
        useCase.exitGroupFailure
            .bind(to: exitGroupFailure)
            .disposed(by: disposeBag)
    }
    
    private func fetchGroupDetail() {
        useCase.fetchGroupDetail(groupID: groupID)
    }
    
    private func createGroupMemberPrayDetailVM(index: Int) {
        let item = mediatorItemList.value[index]
        listVM.accept(GroupMemberPrayListVM(useCase: useCase, groupID: groupID, userID: item.userID))
    }
    
    private func checkIsLeader() {
        if isLeader.value {
            showExitConfirmPopup.accept(())
        } else {
            exitGroup()
        }
    }
    
    private func exitGroup() {
        useCase.exitGroup(groupID: groupID)
    }
}

extension GroupDetailVM {
    struct Input {
        var selectUser: Driver<IndexPath> = .empty()
        var exitGroup: Driver<Void> = .empty()
        var exitGroupLeader: Driver<Void> = .empty()
    }

    struct Output {
        // MARK: - State
        let isNetworking: Driver<Bool>
        
        // MARK: - Data
        let hasJoinReq: Driver<Bool>
        let isLeader: Driver<Bool>
        let groupName: Driver<String>
        let desc: Driver<String>
        let mediatorItemList: Driver<[MediatorItem]>
        let memberList: Driver<[MediatorItem]>
        
        // MARK: - VM
        let listVM: Driver<GroupMemberPrayListVM?>
        
        // MARK: - Event
        let showExitConfirmPopup: Driver<Void>
        let exitGroupSuccess: Driver<Void>
        let exitGroupFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.selectUser
            .drive(onNext: { [weak self] index in
                self?.createGroupMemberPrayDetailVM(index: index.row)
            }).disposed(by: disposeBag)
        
        input.exitGroup
            .drive(onNext: { [weak self] _ in
                self?.checkIsLeader()
            }).disposed(by: disposeBag)
        
        input.exitGroupLeader
            .drive(onNext: { [weak self] _ in
                self?.exitGroup()
            }).disposed(by: disposeBag)
        
        return Output(isNetworking: isNetworking.asDriver(),
                      
                      hasJoinReq: hasJoinReq.asDriver(),
                      isLeader: isLeader.asDriver(),
                      groupName: groupName.asDriver(),
                      desc: desc.asDriver(),
                      mediatorItemList: mediatorItemList.asDriver(),
                      memberList: memberList.asDriver(),
                      
                      listVM: listVM.asDriver(),
                      
                      showExitConfirmPopup: showExitConfirmPopup.asDriver(),
                      exitGroupSuccess: exitGroupSuccess.asDriver(),
                      exitGroupFailure: exitGroupFailure.asDriver()
        )
    }
}

extension GroupDetailVM {
    struct MediatorItem {
        let name: String
        let category: String
        let date: String
        let prayID: String
        let userID: String
        let isLeader: Bool
        
        init(groupDetailPray: GroupDetailPray) {
            name = groupDetailPray.userName + "의 중보기도"
            category = groupDetailPray.category
            date = groupDetailPray.latestDate.isoToDateString("yyyy.M.d") ?? ""
            prayID = groupDetailPray.prayID
            userID = groupDetailPray.userID
            isLeader = false
        }
        
        init(groupMember: GroupMember) {
            name = groupMember.userName
            category = "중보 기도 요청이 없습니다."
            date = ""
            prayID = ""
            userID = groupMember.userID
            isLeader = groupMember.isLeader
        }
    }
}
