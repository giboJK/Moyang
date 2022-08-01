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
    
    let isWeek = BehaviorRelay<Bool>(value: true)
    let myLatestPray = BehaviorRelay<PrayItem?>(value: nil)
    let cardPrayItemList = BehaviorRelay<[PrayItem]>(value: [])
    let amenItemList = BehaviorRelay<[AmenItem]>(value: [])
    let detailVM = BehaviorRelay<GroupPrayListVM?>(value: nil)
    
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
                self.groupName.accept(data.groupName)
                self.setPrayData(data: data.prays)
                self.setAmenData(data: data.amens)
            }).disposed(by: disposeBag)
        
    }
    
    private func setPrayData(data: [GroupSummaryPray]) {
        guard let myInfo = UserData.shared.userInfo else {
            Log.e("Error")
            return
        }
        var cardList = [PrayItem]()
        data.filter { $0.userID != myInfo.id }.forEach { item in
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
        
        if let myData = data.first(where: { $0.userID == myInfo.id }) {
            myLatestPray.accept(PrayItem(memberID: myData.userID,
                                   name: myData.userName,
                                   prayID: myData.content,
                                   pray: myData.content,
                                   tags: myData.tags,
                                   latestDate: myData.latestDate,
                                   isSecret: myData.isSecret,
                                   createDate: myData.createDate))
        } else {
            Log.e("No pray")
        }
    }
    
    private func setAmenData(data: [GroupSummaryAmen]) {
    }
    
    private func clearAutoSave() {
        UserData.shared.clearAutoSave()
    }
    
    @objc func setReactionVM(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            Log.e(""); return
        }
//        let reactions = cardPrayItemList.value[index].reactions
//        prayReactionDetailVM.accept(PrayReactionDetailVM(reactions: reactions))
    }
    
    @objc func setReplyVM(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            Log.e(""); return
        }
//        let replys = cardPrayItemList.value[index].replys
//        prayReplyDetailVM.accept(PrayReplyDetailVM(replys: replys))
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
        let isWeek: Driver<Bool>
        let myLatestPray: Driver<PrayItem?>
        let cardPrayItemList: Driver<[PrayItem]>
        let amenItemList: Driver<[AmenItem]>
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
                let detailVM = GroupPrayListVM(prayItem: self.cardPrayItemList.value[indexPath.row],
                                               useCase: self.useCase)
                self.detailVM.accept(detailVM)
            }).disposed(by: disposeBag)
        
        input.releaseDetailVM
            .drive(onNext: { [weak self] _ in
                self?.detailVM.accept(nil)
            }).disposed(by: disposeBag)
        
        return Output(groupName: groupName.asDriver(),
                      isWeek: isWeek.asDriver(),
                      myLatestPray: myLatestPray.asDriver(),
                      cardPrayItemList: cardPrayItemList.asDriver(),
                      amenItemList: amenItemList.asDriver(),
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
}
