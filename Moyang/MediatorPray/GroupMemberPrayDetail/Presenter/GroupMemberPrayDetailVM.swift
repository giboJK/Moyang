//
//  GroupMemberPrayDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/23.
//

import RxSwift
import RxCocoa

class GroupMemberPrayDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    let useCase: GroupUseCase
    
    
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Data
    let groupName = BehaviorRelay<String?>(value: "")
    let category = BehaviorRelay<String?>(value: nil)
    let newContent = BehaviorRelay<String?>(value: nil)
    let contentItemList = BehaviorRelay<[ContentItem]>(value: [])
    
    // MARK: - Events
    let addPraySuccess = BehaviorRelay<Void>(value: ())
    let addPrayFailure = BehaviorRelay<Void>(value: ())
    
    
    init(useCase: GroupUseCase) {
        self.useCase = useCase
        bind()
    }

    deinit { Log.i(self) }

    private func bind() {
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.prayDetail
            .subscribe(onNext: { [weak self] data in
                guard let self = self, let data = data else { return }
                self.setData(data: data)
            }).disposed(by: disposeBag)
        
        useCase.addPraySuccess
            .bind(to: addPraySuccess)
            .disposed(by: disposeBag)
        
        useCase.addPrayFailure
            .bind(to: addPrayFailure)
            .disposed(by: disposeBag)
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
            itemList.append(ContentItem(answer: answer))
        }
        for reply in data.replys {
            itemList.append(ContentItem(reply: reply))
        }
        
        itemList.sort { $0.date < $1.date }
        
        contentItemList.accept(itemList)
    }
    
    func checkCanEdit(indexPath: IndexPath) {
        
    }
    
    func checkCanDelete(indexPath: IndexPath) {
        
    }
}

extension GroupMemberPrayDetailVM {
    struct Input {
    }

    struct Output {
        let isNetworking: Driver<Bool>
        
        let groupName: Driver<String?>
        let category: Driver<String?>
        let newContent: Driver<String?>
        let contentItemList: Driver<[ContentItem]>
        
        let addPraySuccess: Driver<Void>
        let addPrayFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        return Output(isNetworking: isNetworking.asDriver(),
                      
                      groupName: groupName.asDriver(),
                      category: category.asDriver(),
                      newContent: newContent.asDriver(),
                      contentItemList: contentItemList.asDriver(),
                      
                      addPraySuccess: addPraySuccess.asDriver(),
                      addPrayFailure: addPrayFailure.asDriver()
        )
    }
}

extension GroupMemberPrayDetailVM {
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
        
        init(answer: PrayAnswer) {
            id = answer.id
            content = answer.answer
            date = answer.date
            name = "주님"
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
