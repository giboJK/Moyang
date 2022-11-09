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
    let groupName = BehaviorRelay<String?>(value: "")
    let title = BehaviorRelay<String?>(value: nil)
    let groupList = BehaviorRelay<[GroupInfo]>(value: [])
    // Content, Anser, Change
    let contentItemList = BehaviorRelay<[ContentItem]>(value: [])
    
    // MARK: - State
    let isSaveEnabled = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Events
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    
    let deletePraySuccess = BehaviorRelay<Void>(value: ())
    let deletePrayFailure = BehaviorRelay<Void>(value: ())
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - VM
    let changeAndAnswerVM = BehaviorRelay<ChangeAndAnswerVM?>(value: nil)
    
    init(useCase: MyPrayUseCase) {
        self.useCase = useCase
        
        bind()
        fetchMyGroupList()
    }
    
    deinit { Log.i(self) }
    
    private func bind() {
        // MARK: - Data
        useCase.prayDetail
            .subscribe(onNext: { [weak self] data in
                guard let self = self, let data = data else { return }
                self.setData(data: data)
            }).disposed(by: disposeBag)
        
        useCase.myGroupList
            .subscribe(onNext: { [weak self] list in
                var groupList = list.map { GroupInfo(data: $0) }
                self?.groupList.accept(groupList)
            }).disposed(by: disposeBag)
        
        // MARK: - Events
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
        
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
    }
    
    private func fetchMyGroupList() {
        useCase.fetchMyGroupList()
    }
    
    private func setData(data: PrayDetail) {
        title.accept(data.title)
        groupName.accept(data.groupName)
        
        var itemList = [ContentItem]()
        itemList.append(ContentItem(id: data.prayID, content: data.content, date: data.createDate, name: data.userName))
        for change in data.changes {
            itemList.append(ContentItem(change: change, name: data.userName))
        }
        for answer in data.answers {
            itemList.append(ContentItem(answer: answer, name: data.userName))
        }
        for reply in data.replys {
            itemList.append(ContentItem(reply: reply))
        }
        
        itemList.sort { $0.date < $1.date }
        
        contentItemList.accept(itemList)
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
        var startPray: Driver<Void> = .empty()
        var addRecord: Driver<Void> = .empty()
    }

    struct Output {
        // MARK: - Data
        let groupName: Driver<String?>
        let title: Driver<String?>
        let contentItemList: Driver<[ContentItem]>
        let groupList: Driver<[GroupInfo]>
        
        // MARK: - State
        let isSaveEnabled: Driver<Bool>
        
        // MARK: - Events
        let updatePraySuccess: Driver<Void>
        let updatePrayFailure: Driver<Void>
        
        let deletePraySuccess: Driver<Void>
        let deletePrayFailure: Driver<Void>
        
        let isNetworking: Driver<Bool>
        
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
            groupList: groupList.asDriver(),
            
            isSaveEnabled: isSaveEnabled.asDriver(),
            
            updatePraySuccess: updatePraySuccess.asDriver(),
            updatePrayFailure: updatePrayFailure.asDriver(),
            deletePraySuccess: deletePraySuccess.asDriver(),
            deletePrayFailure: deletePrayFailure.asDriver(),
            
            isNetworking: isNetworking.asDriver(),
            
            changeAndAnswerVM: changeAndAnswerVM.asDriver()
        )
    }
}


extension MyPrayDetailVM {
    struct ContentItem {
        let id: String
        let content: String
        let date: String
        let name: String
        let type: ContentItemType
        
        init(id: String, content: String, date: String, name: String) {
            self.id = id
            self.content = content
            self.date = date
            self.name = name
            type = .startPray
        }
        
        init(change: PrayChange, name: String) {
            id = change.id
            content = change.content
            date = change.date
            self.name = name
            type = .change
        }
        
        init(answer: PrayAnswer, name: String) {
            id = answer.id
            content = answer.answer
            date = answer.date
            self.name = name
            type = .answer
        }
        
        init(reply: PrayReply) {
            id = reply.id
            content = reply.reply
            date = reply.createDate
            name = reply.name
            type = .reply
        }
    }
    
    enum ContentItemType {
        case startPray
        case change
        case answer
        case reply
    }
    
    struct GroupInfo {
        let id: String
        let name: String
        
        init(data: MyGroup) {
            id = data.id
            name = data.name
        }
        
        init(id: String, name: String) {
            self.id = id
            self.name = name
        }
    }
}
