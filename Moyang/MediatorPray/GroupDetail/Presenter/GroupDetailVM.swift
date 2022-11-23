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
    let isLeader = BehaviorRelay<Bool>(value: false)
    let groupName = BehaviorRelay<String>(value: "")
    let desc = BehaviorRelay<String>(value: "")
    let mediatorItemList = BehaviorRelay<[MediatorItem]>(value: [])

    // MARK: - VM
    let listVM = BehaviorRelay<GroupMemberPrayListVM?>(value: nil)
    
    
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
                var itemList = [MediatorItem]()
                for pray in detail.prays {
                    itemList.append(MediatorItem(groupDetailPray: pray))
                }
                itemList.sort { $0.date < $1.date }

                for member in detail.members {
                    if !itemList.contains(where: { $0.userID == member.userID }) {
                        itemList.append(MediatorItem(groupMember: member))
                    }
                }
                
                self.mediatorItemList.accept(itemList)
            }).disposed(by: disposeBag)
    }
    
    private func fetchGroupDetail() {
        useCase.fetchGroupDetail(groupID: groupID)
    }
    
    private func createGroupMemberPrayDetailVM(index: Int) {
        let item = mediatorItemList.value[index]
        listVM.accept(GroupMemberPrayListVM(useCase: useCase, groupID: groupID, userID: item.userID))
    }
}

extension GroupDetailVM {
    struct Input {
        var selectUser: Driver<IndexPath> = .empty()
        var exitGroup: Driver<Void> = .empty()
    }

    struct Output {
        // MARK: - State
        let isNetworking: Driver<Bool>
        
        // MARK: - Data
        let isLeader: Driver<Bool>
        let groupName: Driver<String>
        let desc: Driver<String>
        let mediatorItemList: Driver<[MediatorItem]>
        
        // MARK: - VM
        let listVM: Driver<GroupMemberPrayListVM?>
    }

    func transform(input: Input) -> Output {
        input.selectUser
            .drive(onNext: { [weak self] index in
                self?.createGroupMemberPrayDetailVM(index: index.row)
            }).disposed(by: disposeBag)
        return Output(isNetworking: isNetworking.asDriver(),
                      isLeader: isLeader.asDriver(),
                      groupName: groupName.asDriver(),
                      desc: desc.asDriver(),
                      mediatorItemList: mediatorItemList.asDriver(),
                      listVM: listVM.asDriver()
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
        
        init(groupDetailPray: GroupDetailPray) {
            name = groupDetailPray.userName + "의 중보기도"
            category = groupDetailPray.category
            date = groupDetailPray.latestDate.isoToDateString("yyyy.M.d") ?? ""
            prayID = groupDetailPray.prayID
            userID = groupDetailPray.userID
        }
        
        init(groupMember: GroupMember) {
            name = groupMember.userName + "의 중보기도"
            category = "중보 기도 요청이 없습니다."
            date = ""
            prayID = ""
            userID = groupMember.userID
        }
    }
}
