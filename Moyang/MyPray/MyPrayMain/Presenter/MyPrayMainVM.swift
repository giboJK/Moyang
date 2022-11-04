//
//  MyPrayMainVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/18.
//

import RxSwift
import RxCocoa

class MyPrayMainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: MyPrayUseCase
    let bibleUseCase: BibleUseCase
    
    // MARK: - Networking Event
    
    
    // MARK: - PrayDetail
    let detailVM = BehaviorRelay<MyPrayDetailVM?>(value: nil)
    
    init(useCase: MyPrayUseCase, bibleUseCase: BibleUseCase) {
        self.useCase = useCase
        self.bibleUseCase = bibleUseCase
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
    }
}

extension MyPrayMainVM {
    struct Input {
        let selectPray: Driver<Void>
    }

    struct Output {
        let detailVM: Driver<MyPrayDetailVM?>
    }

    func transform(input: Input) -> Output {
        
        return Output(detailVM: detailVM.asDriver())
    }
}

extension MyPrayMainVM {
    struct PrayItem {
        let prayID: String
        let userID: String
        let title: String
        let content: String
        var latestDate: String
        let createDate: String
        
        init(data: MyPray) {
            self.prayID = data.prayID
            self.userID = data.userID
            self.title = data.title
            self.content = data.content
            self.latestDate = data.latestDate
            self.createDate = data.createDate
        }
    }
    
    struct SearchPrayItem {
        let id: String
        let userID: String
        let name: String
        let date: String
        let pray: String
        let tags: [String]
        
        init(data: SearchedPray) {
            self.id = data.prayID
            self.userID = data.userID
            self.name = data.userName
            self.date = data.latestDate
            self.pray = data.pray
            self.tags = data.tags
        }
    }
}

enum MyPrayOrder: String {
    case latest = "최근순"
    case oldest = "오래된순"
    case isAnswerd = "응답받음"
    case date = "날짜 선택"
    
    var parameter: String {
        switch self {
        case .latest:
            return "latest"
        case .oldest:
            return "oldest"
        case .isAnswerd:
            return "answered"
        case .date:
            return ""
        }
    }
}
