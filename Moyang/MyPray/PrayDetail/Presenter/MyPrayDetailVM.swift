//
//  MyPrayDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/04.
//

import RxSwift
import RxCocoa

class MyPrayDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    
    let useCase: MyPrayUseCase
    
    var myPray: MyPray!
    
    // MARK: - Data
    let groupName = BehaviorRelay<String>(value: "")
    let title = BehaviorRelay<String?>(value: nil)
    // Content, Anser, Change
    let contentItemList = BehaviorRelay<[ContentItem]>(value: [])
    
    // MARK: - State
    let isSaveEnabled = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Events
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    
    let deletePraySuccess = BehaviorRelay<Void>(value: ())
    let deletePrayFailure = BehaviorRelay<Void>(value: ())
    
    // MARK: - VM
    let changeAndAnswerVM = BehaviorRelay<ChangeAndAnswerVM?>(value: nil)
    
    init(useCase: MyPrayUseCase) {
        self.useCase = useCase
        
        bind()
//        testData()
    }
    
    deinit { Log.i(self) }
    
    
    private func testData() {
        var list = [ContentItem]()
        
        list.append(ContentItem(id: "", content: "1111111111111111,1111111111111111", date: "22.8.18. 수", isMe: true))
        list.append(ContentItem(id: "", content: "2222222222222222", date: "22.8.18. 수", isMe: false))
        list.append(ContentItem(id: "", content: "3333333333333333,3333333333333333,3333333333333333", date: "22.08.18. 수", isMe: true))
        list.append(ContentItem(id: "", content: "4444444444444444", date: "22.8.18. 수", isMe: false))
        list.append(ContentItem(id: "", content: "5555555555555555", date: "22.8.18. 수", isMe: true))
        list.append(ContentItem(id: "", content: "6666666666666666,6666666666666666,6666666666666666,6666666666666666", date: "22.08.18. 수", isMe: false))
        list.append(ContentItem(id: "", content: "7777777777777777", date: "22.8.18. 수", isMe: true))
        list.append(ContentItem(id: "", content: "8888888888888888,8888888888888888,8888888888888888,8888888888888888", date: "22.08.18. 수", isMe: false))
        list.append(ContentItem(id: "", content: "9999999999999999", date: "22.8.18. 수", isMe: true))
        list.append(ContentItem(id: "", content: "1111111111111111", date: "22.8.18. 수", isMe: true))
        list.append(ContentItem(id: "", content: "2222222222222222", date: "22.8.18. 수", isMe: true))
        list.append(ContentItem(id: "", content: "3333333333333333", date: "22.8.18. 수", isMe: true))
        list.append(ContentItem(id: "", content: "4444444444444444,4444444444444444", date: "22.8.18. 수", isMe: true))
        list.append(ContentItem(id: "", content: "5555555555555555", date: "22.8.18. 수", isMe: false))
        list.append(ContentItem(id: "", content: "0000000000000000", date: "22.8.18. 수", isMe: false))
        contentItemList.accept(list)
    }
        
    private func bind() {
        useCase.prayDetail
            .subscribe(onNext: { [weak self] data in
                guard let self = self, let data = data else { return }
                self.setData(data: data)
            }).disposed(by: disposeBag)
        
        useCase.updatePraySuccess
            .bind(to: updatePraySuccess)
            .disposed(by: disposeBag)
        
        useCase.updatePrayFailure
            .bind(to: updatePrayFailure)
            .disposed(by: disposeBag)
        
        useCase.deletePraySuccess
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.deletePraySuccess.accept(())
                NotificationCenter.default.post(name: NSNotification.Name.ReloadPrayMainSummary,
                                                object: nil, userInfo: nil)
            }).disposed(by: disposeBag)
        
        useCase.deletePrayFailure
            .bind(to: deletePrayFailure)
            .disposed(by: disposeBag)
    }
    
    private func setData(data: PrayDetail) {
        title.accept(data.title)
        groupName.accept(data.groupName ?? "")
    }
    
    private func setChangeAndAnswerVM() {
//        changeAndAnswerVM.accept(ChangeAndAnswerVM(useCase: useCase, userID: userID, prayID: prayID))
    }
    
    private func updatePray() {
        guard let title = self.title.value else { return }
//        useCase.updatePray(prayID: prayID, pray: pray)
    }
    
    private func deletePray() {
        useCase.deletePray()
    }
}

extension MyPrayDetailVM {
    struct Input {
        var setTitle: Driver<String?> = .empty()
        var updatePray: Driver<Void> = .empty()
        var deletePray: Driver<Void> = .empty()
    }

    struct Output {
        // MARK: - Data
        let groupName: Driver<String>
        let title: Driver<String?>
        let contentItemList: Driver<[ContentItem]>
        
        // MARK: - State
        let isSaveEnabled: Driver<Bool>
        
        // MARK: - Events
        let updatePraySuccess: Driver<Void>
        let updatePrayFailure: Driver<Void>
        
        let deletePraySuccess: Driver<Void>
        let deletePrayFailure: Driver<Void>
        
        // MARK: - VM
        let changeAndAnswerVM: Driver<ChangeAndAnswerVM?>
    }

    func transform(input: Input) -> Output {
        input.setTitle.skip(1)
            .drive(title)
            .disposed(by: disposeBag)
        
        input.updatePray
            .drive(onNext: { [weak self] _ in
                self?.updatePray()
            }).disposed(by: disposeBag)
        
        input.deletePray
            .drive(onNext: { [weak self] _ in
                self?.deletePray()
            }).disposed(by: disposeBag)
        
        
        return Output(
            groupName: groupName.asDriver(),
            title: title.asDriver(),
            contentItemList: contentItemList.asDriver(),
            
            isSaveEnabled: isSaveEnabled.asDriver(),
            
            updatePraySuccess: updatePraySuccess.asDriver(),
            updatePrayFailure: updatePrayFailure.asDriver(),
            deletePraySuccess: deletePraySuccess.asDriver(),
            deletePrayFailure: deletePrayFailure.asDriver(),
            
            changeAndAnswerVM: changeAndAnswerVM.asDriver()
        )
    }
}


extension MyPrayDetailVM {
    struct ContentItem {
        let id: String
        let content: String
        let date: String
        let isMe: Bool
        
        init(id: String, content: String, date: String, isMe: Bool) {
            self.id = id
            self.content = content
            self.date = date
            self.isMe = isMe
        }
    }
}
