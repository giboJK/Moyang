//
//  ChangeAndAnswerVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/18.
//

import RxSwift
import RxCocoa

class ChangeAndAnswerVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: PrayUseCase
    let userID: String
    let prayID: String
    var groupIndividualPray: GroupIndividualPray!

    init(useCase: PrayUseCase, userID: String, prayID: String) {
        self.useCase = useCase
        self.userID = userID
        self.prayID = prayID
        
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.memberPrayList
            .subscribe(onNext: { [weak self] dict in
                guard let self = self else { return }
                if let list = dict[self.userID] {
                    if let pray = list.first(where: { $0.prayID == self.prayID }) {
                        self.setData(data: pray)
                    }
                }
            }).disposed(by: disposeBag)
    }
    private func setData(data: GroupIndividualPray) {
        self.groupIndividualPray = data
    }
}

extension ChangeAndAnswerVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
