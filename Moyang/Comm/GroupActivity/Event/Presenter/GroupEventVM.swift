//
//  GroupEventVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/30.
//

import RxSwift
import RxCocoa

class GroupEventVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let groupUseCase: GroupUseCase
    let prayUseCase: PrayUseCase
    
    let events = BehaviorRelay<[EventItem]>(value: [])

    init(groupUseCase: GroupUseCase, prayUseCase: PrayUseCase) {
        self.groupUseCase = groupUseCase
        self.prayUseCase = prayUseCase
        if let date = Date().startOfWeek?.toString("yyyy-MM-dd hh:mm:ss Z") {
            fetchNews(date: date)
        }
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        groupUseCase.groupEvents
            .subscribe(onNext: { [weak self] events in
                var list = [EventItem]()
                events.forEach { event in
                    list.append(EventItem(id: event.id,
                                          date: event.createDate,
                                          userName: event.userName,
                                          targetUserName: event.targetUserName,
                                          eventType: event.eventType,
                                          preview: event.preview))
                }
                self?.events.accept(list)
            }).disposed(by: disposeBag)
    }
    
    // 1주씩
    private func fetchNews(date: String) {
        groupUseCase.fetchEvents(date: date)
    }
    
    func fetchMoreNews() {
        
    }
}

extension GroupEventVM {
    struct Input {
        let selectNews: Driver<IndexPath>
    }

    struct Output {
        let news: Driver<[EventItem]>
    }

    func transform(input: Input) -> Output {
        return Output(news: events.asDriver())
    }
    
    struct EventItem {
        let id: String
        let date: String
        let userName: String
        let targetUserName: String?
        let eventType: String
        let preview: String?
        
        init(id: String,
             date: String,
             userName: String,
             targetUserName: String?,
             eventType: String,
             preview: String?) {
            self.id = id
            self.date = date
            self.userName = userName
            self.targetUserName = targetUserName
            self.eventType = eventType
            self.preview = preview
        }
    }
}
