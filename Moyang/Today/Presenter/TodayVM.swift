//
//  TodayVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/10.
//

import RxSwift
import RxCocoa

class TodayVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    
    let greeting = BehaviorRelay<String>(value: "")
    let morning = BehaviorRelay<String>(value: "")
    let afternoon = BehaviorRelay<String>(value: "")
    let night = BehaviorRelay<String>(value: "")
    let morningList = BehaviorRelay<[TodayTaskItem]>(value: [])
    let afternoonList = BehaviorRelay<[TodayTaskItem]>(value: [])
    let nightList = BehaviorRelay<[TodayTaskItem]>(value: [])

    init() {
        setupData()
    }

    deinit { Log.i(self) }
    
    private func setupData() {
        guard let myInfo = UserData.shared.userInfo else { Log.e("No Info"); return }
        let hour = Calendar.current.component(.hour, from: Date())
        
        var greeting = ""
        switch hour {
        case 5..<11 : greeting = "평안한 아침이에요!"
        case 11..<13 : greeting = "평안한 오후네요,"
        case 13..<17 : greeting = "평안한 오후네요,"
        case 17..<22 : greeting = "평안한 저녁이에요,"
        default: greeting = "평안한 밤이네요,"
        }
        greeting += " " + myInfo.name
        self.greeting.accept(greeting)
        
        morning.accept(Date().toString("M월 d일의 시작"))
        afternoon.accept("오후에도 주님과")
        night.accept("평안한 밤")
        
        morningList.accept([TodayTaskItem(type: 0, title: "ddd", content: "asdd", isDone: true),
                            TodayTaskItem(type: 1, title: "ddd", content: "asdd", isDone: false),
                            TodayTaskItem(type: 2, title: "ddd", content: "asdd", isDone: false)])
        afternoonList.accept([TodayTaskItem(type: 0, title: "ddd", content: "asdd", isDone: false),
                              TodayTaskItem(type: 4, title: "ddd", content: "asdd", isDone: false)])
        nightList.accept([TodayTaskItem(type: 5, title: "ddd", content: "asdd", isDone: false)])
        
    }
}

extension TodayVM {
    struct Input {

    }

    struct Output {
        let greeting: Driver<String>
        let morning: Driver<String>
        let afternoon: Driver<String>
        let night: Driver<String>
        
        let morningList: Driver<[TodayTaskItem]>
        let afternoonList: Driver<[TodayTaskItem]>
        let nightList: Driver<[TodayTaskItem]>
    }

    func transform(input: Input) -> Output {
        return Output(greeting: greeting.asDriver(),
                      morning: morning.asDriver(),
                      afternoon: afternoon.asDriver(),
                      night: night.asDriver(),
                      
                      morningList: morningList.asDriver(),
                      afternoonList: afternoonList.asDriver(),
                      nightList: nightList.asDriver()
        )
    }
    
    struct TodayTaskItem {
        let type: Int
        let title: String
        let content: String
        let isDone: Bool
        
        init(type: Int,
             title: String,
             content: String,
             isDone: Bool) {
            self.type = type
            self.title = title
            self.content = content
            self.isDone = isDone
        }
    }
}
