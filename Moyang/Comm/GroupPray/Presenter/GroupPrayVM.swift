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
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let groupName = BehaviorRelay<String>(value: "")
    let groupCreateDate = BehaviorRelay<Date?>(value: nil)
    
    let isWeek = BehaviorRelay<Bool>(value: true)
    let cardPrayItemList = BehaviorRelay<[PrayItem]>(value: [])
    let amenItemList = BehaviorRelay<[AmenItem]>(value: [])
    let detailVM = BehaviorRelay<GroupPrayListVM?>(value: nil)
    
    let order = BehaviorRelay<GroupPrayOrder>(value: .latest)
    let selectedMember = BehaviorRelay<String>(value: "")
    let memberList = BehaviorRelay<[MemberItem]>(value: [])
    
    let prayReactionDetailVM = BehaviorRelay<PrayReactionDetailVM?>(value: nil)
    let prayReplyDetailVM = BehaviorRelay<PrayReplyDetailVM?>(value: nil)
    
    init(useCase: CommunityMainUseCase) {
        self.useCase = useCase
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
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.groupSummary
            .subscribe(onNext: { [weak self] data in
                guard let data = data else { return }
                guard let self = self else { return }
                self.groupName.accept(data.groupInfo.groupName)
                self.setPrayData(data: data.prays)
                self.setAmenData(data: data.amens)
                self.setMemberList(data: data.prays)
                self.groupCreateDate.accept(data.groupInfo.createDate.isoToDate())
            }).disposed(by: disposeBag)
    }
    
    private func setPrayData(data: [GroupSummaryPray]) {
        var cardList = [PrayItem]()
        data.forEach { item in
            cardList.append(PrayItem(memberID: item.userID,
                                     name: item.userName,
                                     prayID: item.prayID,
                                     pray: item.content,
                                     tags: item.tags,
                                     latestDate: item.latestDate.isoToDateString(),
                                     isSecret: item.isSecret,
                                     createDate: item.createDate.isoToDateString()))
        }
        cardPrayItemList.accept(cardList)
    }
    
    private func setAmenData(data: [GroupSummaryAmen]) {
    
    }
    
    private func setMemberList(data: [GroupSummaryPray]) {
        var list = data.map { MemberItem(id: $0.userID, name: $0.userName) }
        var allItem = MemberItem(id: "", name: "모두")
        allItem.isChecked = true
        list.append(allItem)
        memberList.accept(list)
    }
    
    @objc func setReactionVM(notification: NSNotification) {
//        guard let index = notification.userInfo?["index"] as? Int else {
//            Log.e(""); return
//        }
//        let reactions = cardPrayItemList.value[index].reactions
//        prayReactionDetailVM.accept(PrayReactionDetailVM(reactions: reactions))
    }
    
    @objc func setReplyVM(notification: NSNotification) {
//        guard let index = notification.userInfo?["index"] as? Int else {
//            Log.e(""); return
//        }
//        let replys = cardPrayItemList.value[index].replys
//        prayReplyDetailVM.accept(PrayReplyDetailVM(replys: replys))
    }
    
    func changeOrder(_ value: GroupPrayOrder) {
        self.order.accept(value)
    }
    
    func selectDate(date: Date) {
        Log.d(date)
    }
}

extension GroupPrayVM {
    struct Input {
        var toggleIsWeek: Driver<Void> = .empty()
        
        var selectMember: Driver<IndexPath> = .empty()
        var releaseDetailVM: Driver<Void> = .empty()
    }
    
    struct Output {
        let groupName: Driver<String>
        let groupCreateDate: Driver<Date?>
        let isWeek: Driver<Bool>
        let cardPrayItemList: Driver<[PrayItem]>
        let amenItemList: Driver<[AmenItem]>
        let order: Driver<GroupPrayOrder>
        let selectedMember: Driver<String>
        let memberList: Driver<[MemberItem]>
        let detailVM: Driver<GroupPrayListVM?>
        let prayReactionDetailVM: Driver<PrayReactionDetailVM?>
        let prayReplyDetailVM: Driver<PrayReplyDetailVM?>
    }
    
    func transform(input: Input) -> Output {
        input.toggleIsWeek
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isWeek.accept(!self.isWeek.value)
            }).disposed(by: disposeBag)
        
        input.selectMember
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.selectedMember.accept(self.memberList.value[indexPath.row].name)
                var curList = self.memberList.value
                for i in 0 ..< curList.count {
                    curList[i].isChecked = false
                }
                curList[indexPath.row].isChecked = true
                self.memberList.accept(curList)
            }).disposed(by: disposeBag)
        
        input.releaseDetailVM
            .drive(onNext: { [weak self] _ in
                self?.detailVM.accept(nil)
            }).disposed(by: disposeBag)
        
        return Output(groupName: groupName.asDriver(),
                      groupCreateDate: groupCreateDate.asDriver(),
                      isWeek: isWeek.asDriver(),
                      cardPrayItemList: cardPrayItemList.asDriver(),
                      amenItemList: amenItemList.asDriver(),
                      order: order.asDriver(),
                      selectedMember: selectedMember.asDriver(),
                      memberList: memberList.asDriver(),
                      detailVM: detailVM.asDriver(),
                      prayReactionDetailVM: prayReactionDetailVM.asDriver(),
                      prayReplyDetailVM: prayReplyDetailVM.asDriver()
        )
    }
}

extension GroupPrayVM {
    struct AmenItem {
        let date: String
        let goalValue: Int
        let value: Int
        init(date: String,
             goalValue: Int,
             value: Int
        ) {
            self.date = date
            self.goalValue = goalValue
            self.value = value
        }
    }
    
    struct MemberItem {
        let id: String
        let name: String
        var isChecked: Bool
        
        init(id: String,
             name: String
        ) {
            self.id = id
            self.name = name
            isChecked = false
        }
    }
}

enum GroupPrayOrder: String {
    case latest = "최근순"
    case oldest = "오래된순"
    case date = "날짜 선택"
}
