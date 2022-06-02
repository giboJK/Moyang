//
//  GroupPrayDetailVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import RxSwift
import RxCocoa

class GroupPrayDetailVM: VMType {
    typealias PrayItem = CommunityMainVM.GroupIndividualPrayItem
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase

    let name = BehaviorRelay<String>(value: "")

    init(prayItem: PrayItem, useCase: CommunityMainUseCase) {
        self.useCase = useCase
        setInitialData(data: prayItem)
        fetchPrayList()
    }

    deinit { Log.i(self) }
    
    private func setInitialData(data: PrayItem) {
        name.accept(data.name)
    }
    private func fetchPrayList() {
        
    }
}

extension GroupPrayDetailVM {
    struct Input {

    }

    struct Output {
        let name: Driver<String>
    }

    func transform(input: Input) -> Output {
        return Output(name: name.asDriver())
    }
}
