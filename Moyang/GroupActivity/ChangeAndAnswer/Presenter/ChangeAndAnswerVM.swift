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
    let useCase: MyPrayUseCase
    let userID: String
    let prayID: String
    var groupIndividualPray: MyPray!
    
    let itemList = BehaviorRelay<[TableItem]>(value: [])

    init(useCase: MyPrayUseCase, userID: String, prayID: String) {
        self.useCase = useCase
        self.userID = userID
        self.prayID = prayID
        
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
    }
    private func setData(data: MyPray) {
    }
}

extension ChangeAndAnswerVM {
    struct Input {

    }

    struct Output {
        let itemList: Driver<[TableItem]>
    }

    func transform(input: Input) -> Output {
        return Output(itemList: itemList.asDriver())
    }
    
    struct TableItem {
        let type: ChangeAnswerTVCell.ChangeAnswertype
        let date: String
        let content: String
        
        init(type: ChangeAnswerTVCell.ChangeAnswertype,
             date: String,
             content: String) {
            self.type = type
            self.date = date
            self.content = content
        }
    }
}
