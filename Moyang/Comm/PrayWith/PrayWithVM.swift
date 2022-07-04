//
//  PrayWithVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/02.
//

import RxSwift
import RxCocoa

class PrayWithVM: VMType {
    typealias PrayItem = CommunityMainVM.GroupIndividualPrayItem
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    let prayItem: PrayItem
    
    let memberName = BehaviorRelay<String>(value: "")
    let date = BehaviorRelay<String>(value: "")
    let parentPray = BehaviorRelay<String>(value: "")
    let parentTagList = BehaviorRelay<[String]>(value: [])
    
    let reply = BehaviorRelay<String?>(value: nil)
    
    let addingNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addingNewPrayFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: CommunityMainUseCase, prayItme: PrayItem) {
        self.useCase = useCase
        self.prayItem = prayItme
        
        bind()
        setData(data: prayItme)
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.addingNewPraySuccess
            .bind(to: addingNewPraySuccess)
            .disposed(by: disposeBag)
        
        useCase.addingNewPrayFailure
            .bind(to: addingNewPrayFailure)
            .disposed(by: disposeBag)
    }
    
    private func setData(data: PrayItem) {
        memberName.accept(data.name)
        date.accept(data.date)
        parentPray.accept(data.pray)
        parentTagList.accept(data.tags)
    }
    
    private func addReply() {
    }
}

extension PrayWithVM {
    struct Input {
        var setReply: Driver<String?> = .empty()
        var saveReply: Driver<Void> = .empty()
    }

    struct Output {
        let memberName: Driver<String>
        let date: Driver<String>
        let parentPray: Driver<String>
        let parentTagList: Driver<[String]>
        let reply: Driver<String?>
        let addingNewPraySuccess: Driver<Void>
        let addingNewPrayFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.setReply
            .drive(reply)
            .disposed(by: disposeBag)
        
        input.saveReply
            .drive(onNext: { [weak self] _ in
                self?.addReply()
            }).disposed(by: disposeBag)
        
        
        return Output(memberName: memberName.asDriver(),
                      date: date.asDriver(),
                      parentPray: parentPray.asDriver(),
                      parentTagList: parentTagList.asDriver(),
                      reply: reply.asDriver(),
                      addingNewPraySuccess: addingNewPraySuccess.asDriver(),
                      addingNewPrayFailure: addingNewPrayFailure.asDriver()
        )
    }
}
