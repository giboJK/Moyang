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
    let cardPrayItemList = BehaviorRelay<[GroupSummaryPrayItem]>(value: [])
    let latestPrayDate = BehaviorRelay<String>(value: "")
    
    let prayGoalValue = BehaviorRelay<Int>(value: 100)
    let prayProgressValue = BehaviorRelay<Int>(value: 0)
    
    let groupPrayVM = BehaviorRelay<GroupPrayVM?>(value: nil)
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let isEmptyGroup = BehaviorRelay<Bool>(value: true)
    
    let myPrayItem = BehaviorRelay<GroupSummaryPrayItem?>(value: nil)
    
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
        
        useCase.groupSummary
            .subscribe(onNext: { [weak self] data in
                guard let data = data else { return }
                guard let self = self else { return }
                Log.d(data)
                UserData.shared.groupID = data.groupID
                UserData.shared.groupInfo = data.groupInfo
                self.isEmptyGroup.accept(false)
                self.groupName.accept(data.groupInfo.groupName)
                self.setPrayData(data: data.prays)
                self.setAmenData(data: data.amens)
            }).disposed(by: disposeBag)
    }
    
    private func fetchGroupSummary() {
        useCase.fetchGroupSummary()
    }
    private func setAmenData(data: [GroupSummaryAmen]) {
        let totalMin = 300
        var currentMin: Double = 0
        data.forEach { item in
            currentMin += Double(item.time)
        }
        currentMin = round(currentMin / 60)
        prayGoalValue.accept(totalMin)
        prayProgressValue.accept(Int(currentMin))
        
        if let myLastAmen = data.filter({ $0.userID == UserData.shared.userInfo?.id })
            .sorted(by: { $0.date > $1.date }).first, let dateString = myLastAmen.date.isoToDateString() {
            latestPrayDate.accept(dateString)
        } else {
            latestPrayDate.accept("기도기록이 없습니다")
        }
    }
    private func setPrayData(data: [GroupSummaryPray]) {
        var cardList = [GroupSummaryPrayItem]()
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone.current
        data.forEach { item in
            var isThisWeek = false
            if let removeMilliSec = item.latestDate?.split(separator: ".").first {
                let timeString = String(removeMilliSec)+"+00:00"
                if let date = formatter.date(from: timeString) {
                    isThisWeek = Calendar.current.isDateInThisWeek(date)
                }
            }
            cardList.append(GroupSummaryPrayItem(memberID: item.userID,
                                                 name: item.userName,
                                                 prayID: item.prayID ?? "",
                                                 pray: item.content ?? "",
                                                 latestDate: item.latestDate?.isoToDateString() ?? "",
                                                 isSecret: item.isSecret ?? true,
                                                 isAnswered: item.isAnswered ?? false,
                                                 changes: item.changes ?? [],
                                                 createDate: item.createDate?.isoToDateString() ?? "",
                                                 isThisWeek: isThisWeek))
        }
        cardPrayItemList.accept(cardList)
    }
}

extension CommunityMainVM {
    struct Input {
    }
    
    struct Output {
        let isNetworking: Driver<Bool>
        
        let groupName: Driver<String>
        let prayGoalValue: Driver<Int>
        let prayProgressValue: Driver<Int>
        let latestPrayDate: Driver<String>
        let cardPrayItemList: Driver<[GroupSummaryPrayItem]>
        
        let groupPrayVM: Driver<GroupPrayVM?>
        let isEmptyGroup: Driver<Bool>
        
        let myPrayItem: Driver<GroupSummaryPrayItem?>
    }
    
    func transform(input: Input) -> Output {
        return Output(isNetworking: isNetworking.asDriver(),
                      
                      groupName: groupName.asDriver(),
                      prayGoalValue: prayGoalValue.asDriver(),
                      prayProgressValue: prayProgressValue.asDriver(),
                      latestPrayDate: latestPrayDate.asDriver(),
                      cardPrayItemList: cardPrayItemList.asDriver(),
                      
                      groupPrayVM: groupPrayVM.asDriver(),
                      isEmptyGroup: isEmptyGroup.asDriver(),
                      myPrayItem: myPrayItem.asDriver()
        )
    }
    
    struct GroupSummaryPrayItem {
        let memberID: String
        let name: String
        let prayID: String
        let pray: String
        let latestDate: String
        let isSecret: Bool
        let isAnswered: Bool
        let changes: [PrayChange]
        let createDate: String
        let isThisWeek: Bool
        
        init(memberID: String,
             name: String,
             prayID: String,
             pray: String,
             latestDate: String,
             isSecret: Bool,
             isAnswered: Bool,
             changes: [PrayChange],
             createDate: String,
             isThisWeek: Bool
        ) {
            self.memberID = memberID
            self.name = name
            self.prayID = prayID
            self.pray = pray
            self.latestDate = latestDate
            self.isSecret = isSecret
            self.isAnswered = isAnswered
            self.changes = changes
            self.createDate = createDate
            self.isThisWeek = isThisWeek
        }
    }
}
