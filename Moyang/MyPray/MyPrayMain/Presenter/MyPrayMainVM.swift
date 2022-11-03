//
//  MyPrayMainVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/18.
//

import RxSwift
import RxCocoa

class MyPrayMainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: MyPrayUseCase
    let bibleUseCase: BibleUseCase
    
    // MARK: - Networking Event
    // MARK: - Searching
    let keyword = BehaviorRelay<String?>(value: nil)
    let autoCompleteList = BehaviorRelay<[String]>(value: [])
    let searchPrayItemList = BehaviorRelay<[SearchPrayItem]>(value: [])
    
    // MARK: - Pray
    let order = BehaviorRelay<String>(value: MyPrayOrder.latest.rawValue)
    let myPrayList = BehaviorRelay<[PrayItem]>(value: [])
    
    // MARK: - PrayDetail
    let detailVM = BehaviorRelay<MyPrayDetailVM?>(value: nil)
    
    init(useCase: MyPrayUseCase, bibleUseCase: BibleUseCase) {
        self.useCase = useCase
        self.bibleUseCase = bibleUseCase
        bind()
        fetchInitialData()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.myPrayList
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                self.myPrayList.accept(list.map({ PrayItem(data: $0) }))
            }).disposed(by: disposeBag)
    }
    
    private func fetchInitialData() {
        fetchPrays()
    }
    
    func fetchPrays() {
        guard let userID = UserData.shared.userInfo?.id else { return }
        if let orderType = MyPrayOrder(rawValue: order.value) {
            useCase.fetchPrayList(userID: userID, order: orderType.parameter, page: myPrayList.value.count)
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
}

extension MyPrayMainVM {
    struct Input {
        var selectPray: Driver<IndexPath> = .empty()
    }

    struct Output {
        let myPrayList: Driver<[PrayItem]>
        let detailVM: Driver<MyPrayDetailVM?>
    }

    func transform(input: Input) -> Output {
        input.selectPray
            .drive(onNext: { [weak self] index in
                guard let self = self else { return }
                let prayItem = self.myPrayList.value[index.row]
                let detailVM = MyPrayDetailVM(useCase: self.useCase,
                                              bibleUseCase: self.bibleUseCase,
                                              prayID: prayItem.prayID)
                self.detailVM.accept(detailVM)
            }).disposed(by: disposeBag)
        
        return Output(myPrayList: myPrayList.asDriver(),
                      detailVM: detailVM.asDriver())
    }
}

extension MyPrayMainVM {
    struct PrayItem {
        let prayID: String
        let userID: String
        let title: String
        let content: String
        var latestDate: String
        let createDate: String
        
        init(data: MyPray) {
            self.prayID = data.prayID
            self.userID = data.userID
            self.title = data.title
            self.content = data.content
            self.latestDate = data.latestDate
            self.createDate = data.createDate
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

enum MyPrayOrder: String {
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
