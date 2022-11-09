//
//  MyPrayListVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//

import RxSwift
import RxCocoa

class MyPrayListVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: MyPrayUseCase
    
    // MARK: - Events
    let isNetworking = BehaviorRelay<Bool>(value: false)
    let itemList = BehaviorRelay<[[PrayListItem]]>(value: [])
    
    // MARK: - UI
    
    // MARK: - VM
    let detailVM = BehaviorRelay<MyPrayDetailVM?>(value: nil)
    
    init(useCase: MyPrayUseCase) {
        self.useCase = useCase
        bind()
        fetchList()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        // TODO: - 추후 리프레시 추가
        useCase.myPrayList
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                guard !list.isEmpty else { return }
                var itemList = [[PrayListItem]]()
                let flatList = list.map { PrayListItem(data: $0) }
                var curSection = flatList.first!.latestDate.isoToDateString("yyyy. M.")
                var curList = [PrayListItem]()
                for item in flatList {
                    if curSection == item.latestDate.isoToDateString("yyyy. M.") {
                        curList.append(item)
                    } else {
                        itemList.append(curList)
                        curList = [PrayListItem]()
                        curList.append(item)
                        curSection = item.latestDate.isoToDateString("yyyy. M.")
                    }
                }
                itemList.append(curList)
                
                self.itemList.accept(itemList)
                
            }).disposed(by: disposeBag)
    }
    
    private func fetchList() {
        guard let userID = UserData.shared.userInfo?.id else { Log.e(""); return }
        useCase.fetchPrayList(userID: userID, page: 15)
    }
}

extension MyPrayListVM {
    struct Input {

    }

    struct Output {
        let itemList: Driver<[[PrayListItem]]>
    }

    func transform(input: Input) -> Output {
        return Output(itemList: itemList.asDriver())
    }
}

extension MyPrayListVM {
    struct PrayListItem {
        // Pray
        let prayID: String
        let title: String
        let content: String
        var latestDate: String
        let createDate: String
                
        init(data: MyPray) {
            self.prayID = data.prayID
            self.title = data.title
            self.content = data.content
            self.latestDate = data.latestDate
            self.createDate = data.createDate
        }
    }
}
