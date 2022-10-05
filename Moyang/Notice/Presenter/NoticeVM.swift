//
//  NoticeVM.swift
//  Moyang
//
//  Created by kibo on 2022/10/05.
//

import RxSwift
import RxCocoa

class NoticeVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: NoticeUseCase
    
    let notices = BehaviorRelay<[NoticeItem]>(value: [])
    let title = BehaviorRelay<String>(value: "")
    let date = BehaviorRelay<String>(value: "")
    let content = BehaviorRelay<String>(value: "")
    let showNotice = BehaviorRelay<Void>(value: ())

    init(useCase: NoticeUseCase) {
        self.useCase = useCase
        bind()
        fetchNotice()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.notices
            .map { list -> [NoticeItem] in
                return list.map { NoticeItem(item: $0) }
            }.bind(to: notices)
            .disposed(by: disposeBag)
    }
    
    private func fetchNotice() {
        useCase.fetchLotices()
    }
    
    func fetchMoreNotices() {
        useCase.fetchMoreNotices()
    }
    
    private func showNotice(index: Int) {
        let notice = notices.value[index]
        title.accept(notice.title)
        date.accept(notice.date.isoToDateString("yyyy. M. d.") ?? "")
        content.accept(notice.content)
        showNotice.accept(())
    }
}

extension NoticeVM {
    struct Input {
        var showNotice: Driver<IndexPath> = .empty()
    }

    struct Output {
        let notices: Driver<[NoticeItem]>
        let title: Driver<String>
        let date: Driver<String>
        let content: Driver<String>
        let showNotice: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.showNotice
            .drive(onNext: { [weak self] index in
                self?.showNotice(index: index.row)
            }).disposed(by: disposeBag)
        
        return Output(notices: notices.asDriver(),
                      title: title.asDriver(),
                      date: date.asDriver(),
                      content: content.asDriver(),
                      showNotice: showNotice.asDriver()
        )
    }
    
    struct NoticeItem {
        let id: String
        let title: String
        let content: String
        let date: String
        
        init(item: Notice) {
            id = item.id
            title = item.title
            content = item.content
            date = item.date
        }
    }
}
