//
//  GroupPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import RxSwift
import RxCocoa

class GroupPrayVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: PrayUseCase
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let groupName = BehaviorRelay<String>(value: "")
    let groupCreateDate = BehaviorRelay<Date?>(value: nil)
    
    let isWeek = BehaviorRelay<Bool>(value: true)
    let prayItemList = BehaviorRelay<[[GroupPrayItem]]>(value: [])
    let amenItemList = BehaviorRelay<[AmenItem]>(value: [])
    
    let order = BehaviorRelay<String>(value: GroupPrayOrder.latest.rawValue)
    let selectedMember = BehaviorRelay<String>(value: "")
    let memberList = BehaviorRelay<[MemberItem]>(value: [])
    let displayDate = BehaviorRelay<String>(value: "")
    
    let prayReactionDetailVM = BehaviorRelay<PrayReactionDetailVM?>(value: nil)
    let prayReplyDetailVM = BehaviorRelay<PrayReplyDetailVM?>(value: nil)
    
    var curDisplayDate = Date().startOfWeek ?? Date()
    
    init(useCase: PrayUseCase) {
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
        fetchPrayAll()
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
    }
    
    private func setPrayData(data: [String: [GroupIndividualPray]]) {
        var cardList = [[GroupPrayItem]]()
        data.forEach { (_: String, value: [GroupIndividualPray]) in
            cardList.append(value.map({ item in
                GroupPrayItem(memberID: item.userID,
                              name: item.userName,
                              prayID: item.prayID,
                              pray: item.pray,
                              tags: item.tags,
                              latestDate: item.latestDate.isoToDateString() ?? "",
                              isSecret: item.isSecret,
                              isAnswered: item.isAnswered,
                              answer: item.answer,
                              changes: item.changes,
                              replys: [],
                              reactions: [],
                              createDate: item.createDate.isoToDateString() ?? "")
                
            })
            )
        }
        prayItemList.accept(cardList)
    }
    
    private func fetchPrayAll() {
        useCase.fetchPrayAll(order: GroupPrayOrder.latest.parameter)
    }
    
    private func setAmenData(data: [GroupSummaryAmen]) {
        
    }
    
    private func setMemberList(dict: [String: String]) {
        var list = dict.map { MemberItem(id: $0.key, name: $0.value) }
        var allItem = MemberItem(id: "", name: "모두")
        allItem.isChecked = true
        list.append(allItem)
        memberList.accept(list)
    }
    
    @objc func setReactionVM(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            Log.e(""); return
        }
//        let reactions = prayItemList.value[index].reactions
//        prayReactionDetailVM.accept(PrayReactionDetailVM(reactions: reactions))
    }
    
    @objc func setReplyVM(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            Log.e(""); return
        }
//        let replys = prayItemList.value[index].replys
//        prayReplyDetailVM.accept(PrayReplyDetailVM(replys: replys))
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
        let prayItemList: Driver<[[GroupPrayItem]]>
        let amenItemList: Driver<[AmenItem]>
        let order: Driver<String>
        let selectedMember: Driver<String>
        let memberList: Driver<[MemberItem]>
        let displayDate: Driver<String>
        let prayReactionDetailVM: Driver<PrayReactionDetailVM?>
        let prayReplyDetailVM: Driver<PrayReplyDetailVM?>
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
        
        return Output(groupName: groupName.asDriver(),
                      groupCreateDate: groupCreateDate.asDriver(),
                      isWeek: isWeek.asDriver(),
                      prayItemList: prayItemList.asDriver(),
                      amenItemList: amenItemList.asDriver(),
                      order: order.asDriver(),
                      selectedMember: selectedMember.asDriver(),
                      memberList: memberList.asDriver(),
                      displayDate: displayDate.asDriver(),
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
    struct GroupPrayItem {
        let memberID: String
        let name: String
        let prayID: String?
        let pray: String
        let tags: [String]
        let latestDate: String
        let isSecret: Bool
        let isAnswered: Bool
        let answer: String
        let changes: [PrayChange]
        let replys: [PrayReply]
        let reactions: [PrayReaction]
        let createDate: String
        
        init(memberID: String,
             name: String,
             prayID: String?,
             pray: String,
             tags: [String],
             latestDate: String,
             isSecret: Bool,
             isAnswered: Bool,
             answer: String,
             changes: [PrayChange],
             replys: [PrayReply],
             reactions: [PrayReaction],
             createDate: String
        ) {
            self.memberID = memberID
            self.name = name
            self.prayID = prayID
            self.pray = pray
            self.tags = tags
            self.latestDate = latestDate
            self.isSecret = isSecret
            self.isAnswered = isAnswered
            self.answer = answer
            self.changes = changes
            self.replys = replys
            self.reactions = reactions
            self.createDate = createDate
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
