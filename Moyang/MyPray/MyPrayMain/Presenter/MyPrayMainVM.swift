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
    
    // MARK: - Events
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    // MARK: - UI
    let summary = BehaviorRelay<PraySummary?>(value: nil)
    
    // MARK: - VM
    let detailVM = BehaviorRelay<MyPrayDetailVM?>(value: nil)
    
    init(useCase: MyPrayUseCase, bibleUseCase: BibleUseCase) {
        self.useCase = useCase
        self.bibleUseCase = bibleUseCase
        bind()
        fetchSumamry()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.myPraySummary
            .bind(onNext: { [weak self] data in
                guard let data = data else { return }
                self?.summary.accept(PraySummary(data: data))
            }).disposed(by: disposeBag)
    }
    
    private func fetchSumamry() {
        if let date = Date().startOfMonth?.toString("yyyy-MM-dd hh:mm:ss Z") {
            useCase.fetchSummary(date: date)
        }
    }
}

extension MyPrayMainVM {
    struct Input {
        var selectPray: Driver<Void> = .empty()
    }

    struct Output {
        let isNetworking: Driver<Bool>
        let summary: Driver<PraySummary?>
        let detailVM: Driver<MyPrayDetailVM?>
    }

    func transform(input: Input) -> Output {
        
        return Output(isNetworking: isNetworking.asDriver(),
                      summary: summary.asDriver(),
                      detailVM: detailVM.asDriver())
    }
}

extension MyPrayMainVM {
    struct PraySummary {
        let prayID: String?
        let title: String?
        let content: String?
        var latestDate: String?
        let createDate: String?
        let alarmID: String?
        let alarmTime: String?
        let isOn: Bool?
        let countDesc: String?
        
        init(data: MyPraySummary) {
            self.prayID = data.pray?.prayID
            self.title = data.pray?.title
            self.content = data.pray?.content
            self.latestDate = data.pray?.latestDate
            self.createDate = data.pray?.createDate
            self.alarmID = data.alarm?.id
            self.alarmTime = data.alarm?.time
            self.isOn = data.alarm?.isOn
            
            let monthString = Date().toString("M월엔")
            let countString = " \((data.prayCount ?? 0))개의 기도가 있어요."
            self.countDesc = monthString + countString
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
