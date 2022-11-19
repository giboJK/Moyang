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
    
    var initialCategory: String?
    var initialGroup: String?
    
    var newContentType: ContentItemType = .change
    
    // MARK: - Data
    let groupName = BehaviorRelay<String?>(value: "")
    let category = BehaviorRelay<String?>(value: nil)
    let groupList = BehaviorRelay<[GroupInfo]>(value: [])
    // Content, Anser, Change
    let contentItemList = BehaviorRelay<[ContentItem]>(value: [])
    let newContentTypeString = BehaviorRelay<String>(value: ContentItemType.change.typeStr)
    
    // MARK: - State
    let isSaveEnabled = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Events
    let updatePraySuccess = BehaviorRelay<Void>(value: ())
    let updatePrayFailure = BehaviorRelay<Void>(value: ())
    
    let deletePraySuccess = BehaviorRelay<Void>(value: ())
    let deletePrayFailure = BehaviorRelay<Void>(value: ())
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    
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
                self?.groupList.accept(list.map { GroupInfo(data: $0) })
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
        category.accept(data.category)
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
        
        initialCategory = data.category
        initialGroup = data.groupName
    }
    
    private func checkIsSaveEnabled() {
        guard let category = self.category.value else {
            isSaveEnabled.accept(false)
            return
        }
        if category.isEmpty {
            isSaveEnabled.accept(false)
            return
        }
        
        var isChanged = false
        
        isChanged = initialCategory != category
        isChanged = isChanged || (initialGroup != groupName.value)
        
        isSaveEnabled.accept(isChanged)
    }
    
    private func updatePray() {
        guard let category = self.category.value else { return }
        guard let content = self.contentItemList.value.first?.content else { return }
//        useCase.updatePray(prayID: prayID, pray: pray)
    }
    
    private func resetChange() {
        category.accept(initialCategory)
        groupName.accept(initialGroup)
        isSaveEnabled.accept(false)
    }
    
    private func deleteItem(index: IndexPath) {
        
    }
    
    private func deletePray() {
        useCase.deletePray()
    }
    
    func changeType(type: ContentItemType) {
        newContentType = type
        newContentTypeString.accept(newContentType.typeStr)
    }
}

extension MyPrayDetailVM {
    struct Input {
        var setCategory: Driver<String?> = .empty()
        var setGroup: Driver<String?> = .empty()
        var updatePray: Driver<Void> = .empty()
        var resetChange: Driver<Void> = .empty()
        
        var deleteItem: Driver<IndexPath> = .empty()
        var deletePray: Driver<Void> = .empty()
        
        var startPray: Driver<Void> = .empty()
        
        var setType: Driver<Int> = .empty()
    }

    struct Output {
        // MARK: - Data
        let category: Driver<String?>
        let groupName: Driver<String?>
        let contentItemList: Driver<[ContentItem]>
        let groupList: Driver<[GroupInfo]>
        let newContentTypeString: Driver<String>
        
        // MARK: - State
        let isSaveEnabled: Driver<Bool>
        
        // MARK: - Events
        let updatePraySuccess: Driver<Void>
        let updatePrayFailure: Driver<Void>
        
        let deletePraySuccess: Driver<Void>
        let deletePrayFailure: Driver<Void>
        
        let isNetworking: Driver<Bool>
        
    }

    func transform(input: Input) -> Output {
        input.setCategory.skip(1)
            .drive(onNext: { [weak self] category in
                self?.category.accept(category)
                self?.checkIsSaveEnabled()
            }).disposed(by: disposeBag)

        input.setGroup.skip(1)
            .drive(onNext: { [weak self] group in
                guard let group = group else { return }
                if group.isEmpty {
                    self?.groupName.accept(nil)
                } else {
                    self?.groupName.accept(group)
                }
                self?.checkIsSaveEnabled()
            }).disposed(by: disposeBag)
        
        input.updatePray
            .drive(onNext: { [weak self] _ in
                self?.updatePray()
            }).disposed(by: disposeBag)
        
        input.resetChange
            .drive(onNext: { [weak self] _ in
                self?.resetChange()
            }).disposed(by: disposeBag)
        
        input.deleteItem
            .drive(onNext: { [weak self] index in
                self?.deleteItem(index: index)
            }).disposed(by: disposeBag)
        
        input.deletePray
            .drive(onNext: { [weak self] _ in
                self?.deletePray()
            }).disposed(by: disposeBag)
        
        
        return Output(
            category: category.asDriver(),
            groupName: groupName.asDriver(),
            contentItemList: contentItemList.asDriver(),
            groupList: groupList.asDriver(),
            newContentTypeString: newContentTypeString.asDriver(),
            
            isSaveEnabled: isSaveEnabled.asDriver(),
            
            updatePraySuccess: updatePraySuccess.asDriver(),
            updatePrayFailure: updatePrayFailure.asDriver(),
            deletePraySuccess: deletePraySuccess.asDriver(),
            deletePrayFailure: deletePrayFailure.asDriver(),
            
            isNetworking: isNetworking.asDriver()
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
        
        var typeStr: String {
            switch self {
            case .startPray:
                return "기도"
            case .change:
                return "변화"
            case .answer:
                return "응답"
            case .reply:
                return "기도 더하기"
            }
        }
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
