//
//  GroupPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import RxSwift
import RxCocoa
import Foundation

class GroupPrayVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: PrayUseCase
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let groupName = BehaviorRelay<String>(value: "")
    let groupCreateDate = BehaviorRelay<Date?>(value: nil)
    let isWeek = BehaviorRelay<Bool>(value: true)
    let amenItemList = BehaviorRelay<[AmenItem]>(value: [])
    
    let order = BehaviorRelay<String>(value: GroupPrayOrder.latest.rawValue)
    let selectedMember = BehaviorRelay<String>(value: "")
    let memberList = BehaviorRelay<[MemberItem]>(value: [])
    let displayDate = BehaviorRelay<String>(value: "")
    
    let memberPrayList = BehaviorRelay<[String: [GroupIndividualPray]]>(value: [:])
    
    let prayReactionDetailVM = BehaviorRelay<PrayReactionDetailVM?>(value: nil)
    let prayReplyDetailVM = BehaviorRelay<PrayReplyDetailVM?>(value: nil)
    
    let groupPrayDetailVM = BehaviorRelay<GroupPrayDetailVM?>(value: nil)
    
    var curDisplayDate = Date().startOfWeek ?? Date()
    
    init(useCase: PrayUseCase) {
        self.useCase = useCase
        bind()
        fetchPrayAll()
        fetchActivity()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        if let groupInfo = UserData.shared.groupInfo {
            groupName.accept(groupInfo.groupName)
        } else { Log.e("") }
        
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.userIDNameDict
            .subscribe(onNext: { [weak self] dict in
                self?.setMemberList(dict: dict)
            }).disposed(by: disposeBag)

        useCase.memberPrayList
            .bind(to: memberPrayList)
            .disposed(by: disposeBag)
    }
    
    private func fetchPrayAll() {
        useCase.fetchPrayAll(order: GroupPrayOrder.latest.parameter)
    }
    
    private func fetchActivity() {
        guard let groupInfo = UserData.shared.groupInfo else { Log.e(""); return }
        if let dateString = Date().startOfWeek?.toString("yyyy-MM-dd hh:mm:ss Z") {
            useCase.fetchGroupAcitvity(groupID: groupInfo.id, isWeek: true, date: dateString)
        }
    }
    
    private func setMemberList(dict: [String: String]) {
        var list = dict.map { MemberItem(id: $0.key, name: $0.value) }
        list = list.sorted(by: { $0.name < $1.name })
        var allItem = MemberItem(id: "", name: "모두")
        allItem.isChecked = true
        list.append(allItem)
        memberList.accept(list)
    }
    
    func changeOrder(_ value: GroupPrayOrder) {
        order.accept(value.rawValue)
    }
    
    func selectDate(date: Date) {
        order.accept(date.toString("M월 d일"))
    }
    
    func selectDateRange(date: Date) {
        curDisplayDate = date
        if isWeek.value {
            if let endDate = date.endOfWeek {
                var value = ""
                if Date() < endDate {
                    value = date.toString("M월 d일") + "-" + Date().toString("M월 d일")
                } else {
                    value = date.toString("M월 d일") + "-" + endDate.toString("M월 d일")
                }
                displayDate.accept(value)
            }
        } else {
            if let endDate = date.endOfMonth {
                var value = ""
                if Date() < endDate {
                    value = date.toString("M월 d일") + "-" + Date().toString("M월 d일")
                } else {
                    value = date.toString("M월 d일") + "-" + endDate.toString("M월 d일")
                }
                displayDate.accept(value)
            }
        }
    }
    
    func fetchMorePrays(userID: String) {
        if let orderType = GroupPrayOrder(rawValue: order.value),
           let list = memberPrayList.value[userID] {
            useCase.fetchPrayList(userID: userID, order: orderType.parameter, page: list.count)
        }
    }
}

extension GroupPrayVM {
    struct Input {
        var toggleIsWeek: Driver<Void> = .empty()
        
        var selectMember: Driver<IndexPath> = .empty()
        
        var showPrayDetail: Driver<(String, IndexPath)?> = .empty()
        var showReactions: Driver<(String, Int)?> = .empty()
        var showReplys: Driver<(String, Int)?> = .empty()
    }
    
    struct Output {
        let groupName: Driver<String>
        let groupCreateDate: Driver<Date?>
        let isWeek: Driver<Bool>
        let amenItemList: Driver<[AmenItem]>
        
        let order: Driver<String>
        let selectedMember: Driver<String>
        let memberList: Driver<[MemberItem]>
        let displayDate: Driver<String>
        
        let memberPrayList: Driver<[String: [GroupIndividualPray]]>
        
        let prayReactionDetailVM: Driver<PrayReactionDetailVM?>
        let prayReplyDetailVM: Driver<PrayReplyDetailVM?>
        let groupPrayDetailVM: Driver<GroupPrayDetailVM?>
    }
    
    func transform(input: Input) -> Output {
        input.toggleIsWeek
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isWeek.accept(!self.isWeek.value)
                self.selectDateRange(date: self.curDisplayDate)
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
        
        input.showPrayDetail
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                guard let item = item else { return }
                if let prayList = self.memberPrayList.value[item.0] {
                    self.groupPrayDetailVM.accept(GroupPrayDetailVM(useCase: self.useCase,
                                                                    userID: item.0,
                                                                    prayID: prayList[item.1.row].prayID))
                }
            }).disposed(by: disposeBag)
        
        input.showReactions
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                guard let item = item else { return }
                if let prayList = self.memberPrayList.value[item.0] {
                    self.prayReactionDetailVM.accept(PrayReactionDetailVM(reactions: prayList[item.1].reactions))
                }
            }).disposed(by: disposeBag)
        
        input.showReplys
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                guard let item = item else { return }
                if let prayList = self.memberPrayList.value[item.0] {
                    self.prayReplyDetailVM.accept(PrayReplyDetailVM(replys: prayList[item.1].replys))
                }
            }).disposed(by: disposeBag)
        
        
        return Output(groupName: groupName.asDriver(),
                      groupCreateDate: groupCreateDate.asDriver(),
                      isWeek: isWeek.asDriver(),
                      amenItemList: amenItemList.asDriver(),
                      
                      order: order.asDriver(),
                      selectedMember: selectedMember.asDriver(),
                      memberList: memberList.asDriver(),
                      displayDate: displayDate.asDriver(),
                      
                      memberPrayList: memberPrayList.asDriver(),
                      prayReactionDetailVM: prayReactionDetailVM.asDriver(),
                      prayReplyDetailVM: prayReplyDetailVM.asDriver(),
                      groupPrayDetailVM: groupPrayDetailVM.asDriver()
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
    case isAnswerd = "응답받음"
    case date = "날짜 선택"
    
    var parameter: String {
        switch self {
        case .latest:
            return "latest"
        case .oldest:
            return "oldest"
        case .isAnswerd:
            return "answered"
        case .date:
            return ""
        }
    }
}
