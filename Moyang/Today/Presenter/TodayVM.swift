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
    let startString = BehaviorRelay<String>(value: "")

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
        case 17..<22 : greeting = "평안한 저녁시간,"
        default: greeting = "평안한 밤이네요,"
        }
        greeting += " " + myInfo.name
        self.greeting.accept(greeting)
        
        startString.accept(Date().toString("M월 d일의 시작"))
    }
}

extension TodayVM {
    struct Input {

    }

    struct Output {
        let greeting: Driver<String>
        let startString: Driver<String>
    }

    func transform(input: Input) -> Output {
        return Output(greeting: greeting.asDriver(),
                      startString: startString.asDriver()
        )
    }
}
