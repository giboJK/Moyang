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
    let myPray = BehaviorRelay<String>(value: "")
    let cardPrayItemList = BehaviorRelay<[GroupIndividualPrayItem]>(value: [])
    
    private var groupInfo: GroupInfo?
    
    init(useCase: CommunityMainUseCase) {
        self.useCase = useCase
        fetchGroupInfo()
        bind()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        useCase.groupInfo
            .subscribe(onNext: { [weak self] groupInfo in
                guard let groupInfo = groupInfo else { return }
                self?.setGroupInfoData(data: groupInfo)
            }).disposed(by: disposeBag)
        
        useCase.cardMemberPrayList
            .map { list in
                var itemList = [GroupIndividualPrayItem]()
                list.forEach { item in
                    itemList.append(GroupIndividualPrayItem(name: item.member.name,
                                                            pray: item.pray.pray,
                                                            date: item.pray.date,
                                                            prayID: item.pray.id))
                }
                Log.w(itemList)
                return itemList
            }
            .bind(to: cardPrayItemList)
            .disposed(by: disposeBag)
    }
    
    private func fetchGroupInfo() {
        useCase.fetchGroupInfo()
    }
    
    private func setGroupInfoData(data: GroupInfo) {
        Log.w(data)
        groupInfo = data
        groupName.accept(data.groupName)
        getMemberPray(memberList: data.memberList)
    }
    
    private func getMemberPray(memberList: [Member]) {
        guard let groupInfo = groupInfo else { Log.e("No GroupInfo"); return }
        memberList.forEach { member in
            useCase.fetchMemberIndividualPray(member: member, groupID: groupInfo.id, limit: 1)
        }
    }
}

extension CommunityMainVM {
    struct Input {
        
    }
    
    struct Output {
        let groupName: Driver<String>
        let cardPrayItemList: Driver<[GroupIndividualPrayItem]>
    }
    
    func transform(input: Input) -> Output {
        return Output(groupName: groupName.asDriver(),
                      cardPrayItemList: cardPrayItemList.asDriver())
    }
    
    struct GroupIndividualPrayItem {
        let name: String
        let pray: String
        let date: String
        let prayID: String
        
        init(name: String,
             pray: String,
             date: String,
             prayID: String) {
            self.name = name
            self.pray = pray
            self.date = date
            self.prayID = prayID
        }
    }
}
