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
    let cardPrayItemList = BehaviorRelay<[GroupIndividualPrayItem]>(value: [])
    let latestPrayDate = BehaviorRelay<String>(value: "")
    
    let prayGoalValue = BehaviorRelay<Int>(value: 100)
    let prayProgressValue = BehaviorRelay<Int>(value: 0)
    
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
        
        useCase.groupSummary
            .subscribe(onNext: { [weak self] data in
                guard let data = data else { return }
                guard let self = self else { return }
                Log.d(data)
                UserData.shared.groupID = data.groupID
                self.isEmptyGroup.accept(false)
                self.groupName.accept(data.groupName)
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
        var cardList = [GroupIndividualPrayItem]()
        data.forEach { item in
            cardList.append(GroupIndividualPrayItem(memberID: item.userID,
                                                    name: item.userName,
                                                    prayID: item.prayID,
                                                    pray: item.content,
                                                    latestDate: item.latestDate,
                                                    isSecret: item.isSecret,
                                                    createDate: item.createDate))
        }
        cardPrayItemList.accept(cardList)
    }
}

extension CommunityMainVM {
    struct Input {
        var didTapPrayCard: Driver<Void> = .empty()
    }
    
    struct Output {
        let isNetworking: Driver<Bool>
        
        let groupName: Driver<String>
        let prayGoalValue: Driver<Int>
        let prayProgressValue: Driver<Int>
        let latestPrayDate: Driver<String>
        let cardPrayItemList: Driver<[GroupIndividualPrayItem]>
        
        let groupPrayVM: Driver<GroupPrayVM?>
        let isEmptyGroup: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        input.didTapPrayCard
            .drive(onNext: { [weak self] _ in
            }).disposed(by: disposeBag)
        
        return Output(isNetworking: isNetworking.asDriver(),
                      
                      groupName: groupName.asDriver(),
                      prayGoalValue: prayGoalValue.asDriver(),
                      prayProgressValue: prayProgressValue.asDriver(),
                      latestPrayDate: latestPrayDate.asDriver(),
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
