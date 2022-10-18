//
//  GroupActivityVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import RxSwift
import RxCocoa
import Foundation

class GroupActivityVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: MyPrayUseCase
    let bibleUseCase: BibleUseCase
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let greeting = BehaviorRelay<String>(value: "")
    
    let groupName = BehaviorRelay<String>(value: "")
    let groupCreateDate = BehaviorRelay<Date?>(value: nil)
    let isWeek = BehaviorRelay<Bool>(value: true)
    
    let order = BehaviorRelay<String>(value: GroupPrayOrder.latest.rawValue)
    let selectedMember = BehaviorRelay<String>(value: "")
    let memberList = BehaviorRelay<[MemberItem]>(value: [])
    let displayDate = BehaviorRelay<String>(value: "")
    
    let memberPrayList = BehaviorRelay<[String: [MyPray]]>(value: [:])
    
    let keyword = BehaviorRelay<String?>(value: nil)
    let autoCompleteList = BehaviorRelay<[String]>(value: [])
    let searchPrayItemList = BehaviorRelay<[SearchPrayItem]>(value: [])
    
    let prayReactionDetailVM = BehaviorRelay<PrayReactionDetailVM?>(value: nil)
    let prayReplyDetailVM = BehaviorRelay<PrayReplyDetailVM?>(value: nil)
    
    let groupPrayDetailVM = BehaviorRelay<GroupPrayDetailVM?>(value: nil)
    
    // QT
    let bibleSelectVM = BehaviorRelay<BibleSelectVM?>(value: nil)
    let qtDate = BehaviorRelay<String>(value: Date().toString("yyyy년 M월 d일"))
    let bibleVerses = BehaviorRelay<String>(value: "")
    
    var curDisplayDate = Date().startOfWeek ?? Date()
    
    let addingNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addingNewPrayFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: MyPrayUseCase, bibleUseCase: BibleUseCase) {
        self.useCase = useCase
        self.bibleUseCase = bibleUseCase
        
        bind()
        setupGreeting()
        fetchPrayAll()
        setupQTData()
//        if let start = Date().startOfWeek {
//            fetchActivity(start.toString("yyyy-MM-dd hh:mm:ss Z"))
//        }
//        setFirstDate()
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
        
        useCase.autoCompleteList
            .bind(to: autoCompleteList)
            .disposed(by: disposeBag)
        
        useCase.searchedPrayList
            .map { $0.map { SearchPrayItem(data: $0) } }
            .bind(to: searchPrayItemList)
            .disposed(by: disposeBag)
        
        useCase.fetchPraySuccess
            .subscribe(onNext: { [weak self] pray in
                guard let self = self, let pray = pray else { return }
                self.groupPrayDetailVM.accept(GroupPrayDetailVM(useCase: self.useCase, bibleUseCase: self.bibleUseCase,
                                                                userID: pray.userID, prayID: pray.prayID))
                self.removeAutoCompleteList()
            }).disposed(by: disposeBag)
        
        useCase.fetchPrayFailure
            .subscribe(onNext: { [weak self] _ in
                self?.removeAutoCompleteList()
            }).disposed(by: disposeBag)
        
        // network result event
        useCase.addNewPraySuccess
            .bind(to: addingNewPraySuccess)
            .disposed(by: disposeBag)
        
        useCase.addNewPrayFailure
            .bind(to: addingNewPrayFailure)
            .disposed(by: disposeBag)
    }
    
    private func setupGreeting() {
        guard let myInfo = UserData.shared.userInfo else { Log.e("No Info"); return }
        let hour = Calendar.current.component(.hour, from: Date())
        
        var greeting = ""
        switch hour {
        case 5..<11 : greeting = "주님과 함께 시작해요"
        case 11..<13 : greeting = "좋은 오후네요,"
        case 13..<17 : greeting = "좋은 오후네요,"
        case 17..<22 : greeting = "좋은 저녁이에요,"
        default: greeting = "평안한 밤이네요,"
        }
        greeting += "\n" + myInfo.name
        self.greeting.accept(greeting)
    }
    
    private func fetchPrayAll() {
        useCase.fetchPrayAll(order: GroupPrayOrder.latest.parameter)
    }
    
    private func setFirstDate() {
        if let endDate = Date().endOfWeek,
           let startDate = Date().startOfWeek {
            var value = ""
            if Date() < endDate {
                value = startDate.toString("M월 d일") + "-" + Date().toString("M월 d일")
            } else {
                value = startDate.toString("M월 d일") + "-" + endDate.toString("M월 d일")
            }
            displayDate.accept(value)
        }
    }
    
    private func fetchActivity(_ dateString: String) {
        guard let groupInfo = UserData.shared.groupInfo else { Log.e(""); return }
        useCase.fetchGroupAcitvity(groupID: groupInfo.id, isWeek: self.isWeek.value, date: dateString)
    }
    
    private func setMemberList(dict: [String: String]) {
        guard let userInfo = UserData.shared.userInfo else { Log.e("No User info"); return }
        var list = dict.map { MemberItem(id: $0.key, name: $0.value,
                                         isMe: $0.key == userInfo.id) }
        list = list.sorted(by: { $0.name < $1.name })
        var allItem = MemberItem(id: "", name: "모두", isMe: false)
        allItem.isChecked = true
        list.append(allItem)
        if let index = list.firstIndex(where: { $0.id == UserData.shared.userInfo?.id }) {
            list.insert(list.remove(at: index), at: 0)
//            list.remove(at: index)
        }
        memberList.accept(list)
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
        fetchActivity(curDisplayDate.toString("yyyy-MM-dd hh:mm:ss Z"))
    }
    
    func fetchMorePrays(userID: String) {
        if let orderType = GroupPrayOrder(rawValue: order.value),
           let list = memberPrayList.value[userID] {
            useCase.fetchPrayList(userID: userID, order: orderType.parameter, page: list.count)
        }
    }
    
    private func fetchAutocomplete(keyword: String) {
        useCase.fetchAutocompleteList(keyword: keyword)
    }
    private func searchWithKeyword(keyword: String) {
        guard let groupID = UserData.shared.groupID else {
            Log.e(""); return
        }
        useCase.searchWithKeyword(keyword: keyword, groupID: groupID)
    }
    private func fetchPray(prayID: String, userID: String) {
        useCase.fetchPray(prayID: prayID, userID: userID)
    }
    
    private func removeAutoCompleteList() {
        useCase.removeAutoCompleteList()
    }
    
    // MARK: - QT
    private func setupQTData() {
        bibleVerses.accept("창 2:23-30")
    }
}


// MARK: - Extension
extension GroupActivityVM {
    struct Input {
        var selectMember: Driver<IndexPath> = .empty()
        
        var setKeyword: Driver<String?> = .empty()
        var clearKeyword: Driver<Void> = .empty()
        var searchKeyword: Driver<Void> = .empty()
        var fetchAutocomplete: Driver<Void> = .empty()
        var selectAutocomplete: Driver<IndexPath> = .empty()
        var selectSearched: Driver<IndexPath> = .empty()
        
        var showPrayDetail: Driver<(String, IndexPath)?> = .empty()
        var showReactions: Driver<(String, Int)?> = .empty()
        var showReplys: Driver<(String, Int)?> = .empty()
    }
    
    struct Output {
        let greeting: Driver<String>
        
        let groupName: Driver<String>
        let groupCreateDate: Driver<Date?>
        let isWeek: Driver<Bool>
        
        let order: Driver<String>
        let selectedMember: Driver<String>
        let memberList: Driver<[MemberItem]>
        let displayDate: Driver<String>
        
        let memberPrayList: Driver<[String: [MyPray]]>
        let autoCompleteList: Driver<[String]>
        let searchPrayItemList: Driver<[SearchPrayItem]>
        
        let prayReactionDetailVM: Driver<PrayReactionDetailVM?>
        let prayReplyDetailVM: Driver<PrayReplyDetailVM?>
        let groupPrayDetailVM: Driver<GroupPrayDetailVM?>
        
        // QT
        let bibleSelectVM: Driver<BibleSelectVM?>
        let qtDate: Driver<String>
        let bibleVerses: Driver<String>
        
        // Thanks
        
        let addingNewPraySuccess: Driver<Void>
        let addingNewPrayFailure: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
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
        
        input.setKeyword
            .drive(keyword)
            .disposed(by: disposeBag)
        
        input.clearKeyword
            .drive(onNext: { [weak self] _ in
                self?.removeAutoCompleteList()
            }).disposed(by: disposeBag)
        
        input.searchKeyword
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let keyword = self.keyword.value else { return }
                self.searchWithKeyword(keyword: keyword)
            }).disposed(by: disposeBag)
        
        input.fetchAutocomplete
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let keyword = self.keyword.value {
                    if keyword.count < 2 {
                        self.removeAutoCompleteList()
                        return
                    }
                    self.fetchAutocomplete(keyword: keyword)
                }
            }).disposed(by: disposeBag)
        
        input.selectAutocomplete
            .drive(onNext: { [weak self] index in
                guard let self = self else { return }
                let keyword = self.autoCompleteList.value[index.row]
                self.searchWithKeyword(keyword: keyword)
            }).disposed(by: disposeBag)
        
        input.selectSearched
            .drive(onNext: { [weak self] index in
                guard let self = self else { return }
                let id = self.searchPrayItemList.value[index.row].id
                let userID = self.searchPrayItemList.value[index.row].userID
                self.fetchPray(prayID: id, userID: userID)
            }).disposed(by: disposeBag)
        
        input.showPrayDetail
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                guard let item = item else { return }
                if let prayList = self.memberPrayList.value[item.0] {
                    self.groupPrayDetailVM.accept(GroupPrayDetailVM(useCase: self.useCase,
                                                                    bibleUseCase: self.bibleUseCase,
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
                    self.prayReplyDetailVM.accept(PrayReplyDetailVM(useCase: self.useCase,
                                                                    userID: prayList[item.1].userID,
                                                                    prayID: prayList[item.1].prayID,
                                                                    replys: prayList[item.1].replys))
                }
            }).disposed(by: disposeBag)
        
        return Output(greeting: greeting.asDriver(),
                      
                      groupName: groupName.asDriver(),
                      groupCreateDate: groupCreateDate.asDriver(),
                      isWeek: isWeek.asDriver(),
                      
                      order: order.asDriver(),
                      selectedMember: selectedMember.asDriver(),
                      memberList: memberList.asDriver(),
                      displayDate: displayDate.asDriver(),
                      
                      memberPrayList: memberPrayList.asDriver(),
                      autoCompleteList: autoCompleteList.asDriver(),
                      searchPrayItemList: searchPrayItemList.asDriver(),
                      
                      prayReactionDetailVM: prayReactionDetailVM.asDriver(),
                      prayReplyDetailVM: prayReplyDetailVM.asDriver(),
                      groupPrayDetailVM: groupPrayDetailVM.asDriver(),
                      
                      bibleSelectVM: bibleSelectVM.asDriver(),
                      qtDate: qtDate.asDriver(),
                      bibleVerses: bibleVerses.asDriver(),
                      
                      addingNewPraySuccess: addingNewPraySuccess.asDriver(),
                      addingNewPrayFailure: addingNewPrayFailure.asDriver()
        )
    }
}

extension GroupActivityVM {
    struct MemberItem {
        let id: String
        let name: String
        let isMe: Bool
        var isChecked: Bool
        
        init(id: String, name: String, isMe: Bool) {
            self.id = id
            self.name = name
            self.isMe = isMe
            isChecked = false
        }
    }
    
    struct SearchPrayItem {
        let id: String
        let userID: String
        let name: String
        let date: String
        let pray: String
        let tags: [String]
        
        init(data: SearchedPray) {
            self.id = data.prayID
            self.userID = data.userID
            self.name = data.userName
            self.date = data.latestDate
            self.pray = data.pray
            self.tags = data.tags
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
