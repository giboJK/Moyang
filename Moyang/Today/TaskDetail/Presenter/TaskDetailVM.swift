//
//  TaskDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/12.
//

import RxSwift
import RxCocoa

class TaskDetailVM: VMType {
    typealias Item = TodayVM.TodayTaskItem
    var disposeBag: DisposeBag = DisposeBag()
    
    let type = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<Int>(value: 0)
    let isPray = BehaviorRelay<Bool>(value: false)
    let isDoneSuccess = BehaviorRelay<Void>(value: ())

    let item: Item
    init(item: Item) {
        self.item = item
        setupData(item: item)
    }

    deinit { Log.i(self) }
    
    private func setupData(item: Item) {
        type.accept(item.taskType.defaultTitle)
        time.accept(item.taskType.defaultTime)
        isPray.accept(item.taskType == .pray)
    }
}

extension TaskDetailVM {
    struct Input {
        let done: Driver<Void>
    }

    struct Output {
        let type: Driver<String>
        let time: Driver<Int>
        let isPray: Driver<Bool>
        let isDoneSuccess: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.done
            .drive(onNext: { [weak self] _ in
                self?.isDoneSuccess.accept(())
            }).disposed(by: disposeBag)
        
        return Output(type: type.asDriver(),
                      time: time.asDriver(),
                      isPray: isPray.asDriver(),
                      isDoneSuccess: isDoneSuccess.asDriver()
        )
    }
}
