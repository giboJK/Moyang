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
    
    let news = BehaviorRelay<[NewsItem]>(value: [])

    init(groupUseCase: GroupUseCase, prayUseCase: PrayUseCase) {
        self.groupUseCase = groupUseCase
        self.prayUseCase = prayUseCase
        fetchNews()
    }

    deinit { Log.i(self) }
    
    // 1달씩
    private func fetchNews() {
        
    }
    
    func fetchMoreNews() {
        
    }
}

extension GroupEventVM {
    struct Input {
        let selectNews: Driver<IndexPath>
    }

    struct Output {
        let news: Driver<[NewsItem]>
    }

    func transform(input: Input) -> Output {
        return Output(news: news.asDriver())
    }
    
    struct NewsItem {
        let id: String
        let date: String
        let content: String
        
        init(id: String, date: String, content: String) {
            self.id = id
            self.date = date
            self.content = content
        }
    }
}
