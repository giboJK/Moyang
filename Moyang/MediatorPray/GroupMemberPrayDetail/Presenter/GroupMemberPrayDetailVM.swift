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
    
    // MARK: - Propertise
    var prayID: String = ""
    
    
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Data
    let isMe = BehaviorRelay<Bool>(value: false)
    let groupName = BehaviorRelay<String?>(value: "")
    let category = BehaviorRelay<String?>(value: nil)
    let newContent = BehaviorRelay<String?>(value: nil)
    let contentItemList = BehaviorRelay<[ContentItem]>(value: [])
    
    // MARK: - Events
    let addPraySuccess = BehaviorRelay<Void>(value: ())
    let addPrayFailure = BehaviorRelay<Void>(value: ())
    
    let cantEditPopup = BehaviorRelay<Void>(value: ())
    let deleteConfirmPopup = BehaviorRelay<Void>(value: ())
    let showFixVC = BehaviorRelay<Void>(value: ())
    
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
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No my id"); return }
        category.accept(data.category)
        groupName.accept(data.groupName)
        prayID = data.prayID
        
        var itemList = [ContentItem]()
        itemList.append(ContentItem(id: data.prayID,
                                    userID: myID,
                                    content: data.content,
                                    date: data.createDate,
                                    name: data.userName))
        for change in data.changes {
            itemList.append(ContentItem(change: change, userID: myID, name: data.userName))
        }
        for answer in data.answers {
            itemList.append(ContentItem(answer: answer, userID: myID))
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
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No my id"); return }
        let item = contentItemList.value[indexPath.row]
        if item.type == .reply {
            if item.userID != myID {
                cantEditPopup.accept(())
            } else {
                
            }
        } else {
            
        }
    }
    
    private func addPray() {
        if prayID.isEmpty { Log.e("No pray id"); return }
        guard let myID = UserData.shared.userInfo?.id else { Log.e("No user id"); return }
        guard let content = newContent.value else { Log.e("No Content"); return }
        useCase.addReply(prayID: prayID, myID: myID, content: content)
    }
    private func addChange() {
        
    }
    
    private func clearPrayDetail() {
        useCase.clearPrayDetail()
    }
}

extension GroupMemberPrayDetailVM {
    struct Input {
        var addPray: Driver<Void> = .empty()
        var setNew: Driver<String?> = .empty()
        var clearPrayDetail: Driver<Void> = .empty()
    }

    struct Output {
        let isNetworking: Driver<Bool>
        
        let isMe: Driver<Bool>
        let groupName: Driver<String?>
        let category: Driver<String?>
        let newContent: Driver<String?>
        let contentItemList: Driver<[ContentItem]>
        
        let addPraySuccess: Driver<Void>
        let addPrayFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.addPray
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.isMe.value {
                    self.addChange()
                } else {
                    self.addPray()
                }
            }).disposed(by: disposeBag)
        
        input.setNew
            .drive(newContent)
            .disposed(by: disposeBag)
        
        input.clearPrayDetail
            .drive(onNext: { [weak self] _ in
                self?.clearPrayDetail()
            }).disposed(by: disposeBag)
        
        return Output(isNetworking: isNetworking.asDriver(),
                      
                      isMe: isMe.asDriver(),
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
        let userID: String
        let content: String
        let date: String
        let name: String
        let type: ContentItemType
        
        init(id: String, userID: String, content: String, date: String, name: String) {
            self.id = id
            self.userID = userID
            self.content = content
            self.date = date
            self.name = name
            type = .startPray
        }
        
        init(change: PrayChange, userID: String, name: String) {
            id = change.id
            self.userID = userID
            content = change.content
            date = change.date
            self.name = name
            type = .change
        }
        
        init(answer: PrayAnswer, userID: String) {
            id = answer.id
            self.userID = userID
            content = answer.answer
            date = answer.date
            name = "주님"
            type = .answer
        }
        
        init(reply: PrayReply) {
            id = reply.id
            userID = reply.memberID
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
