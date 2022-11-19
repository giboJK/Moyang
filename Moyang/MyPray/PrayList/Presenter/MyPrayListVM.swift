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
    let itemList = BehaviorRelay<([String], [[PrayListItem]])>(value: ([], []))
    
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
                var curSection = flatList.first!.latestDate.isoToDateString("yyyy년 M월")
                var curList = [PrayListItem]()
                var sections = [curSection!]
                for item in flatList {
                    if curSection == item.latestDate.isoToDateString("yyyy년 M월") {
                        curList.append(item)
                    } else {
                        itemList.append(curList)
                        curList = [PrayListItem]()
                        curList.append(item)
                        curSection = item.latestDate.isoToDateString("yyyy년 M월")
                        sections.append(curSection!)
                    }
                }
                itemList.append(curList)
                
                self.itemList.accept((sections, itemList))
            }).disposed(by: disposeBag)
        
        useCase.prayDetail
            .bind(onNext: { [weak self] data in
                guard data != nil else { return }
                self?.createDetailVM()
            }).disposed(by: disposeBag)
        
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
    }
    
    private func fetchList() {
        guard let userID = UserData.shared.userInfo?.id else { Log.e(""); return }
        useCase.fetchPrayList(userID: userID, page: 0)
    }
    
    func fetchMoreList() {
        guard let userID = UserData.shared.userInfo?.id else { Log.e(""); return }
        useCase.fetchMorePrayList(userID: userID)
    }
    
    private func fetchPrayDetail(index: IndexPath) {
        let prayID = itemList.value.1[index.section][index.row].prayID
        useCase.fetchPrayDetail(prayID: prayID)
    }
    
    private func createDetailVM() {
        detailVM.accept(MyPrayDetailVM(useCase: useCase))
    }
}

extension MyPrayListVM {
    struct Input {
        let selectItem: Driver<IndexPath>
    }

    struct Output {
        let isNetworking: Driver<Bool>
        let itemList: Driver<([String], [[PrayListItem]])>
        let detailVM: Driver<MyPrayDetailVM?>
    }

    func transform(input: Input) -> Output {
        input.selectItem
            .drive(onNext: { [weak self] index in
                self?.fetchPrayDetail(index: index)
            }).disposed(by: disposeBag)
        return Output(isNetworking: isNetworking.asDriver(),
                      itemList: itemList.asDriver(),
                      detailVM: detailVM.asDriver()
        )
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
            self.title = data.category
            self.content = data.content
            self.latestDate = data.latestDate
            self.createDate = data.createDate
        }
    }
}
