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
    private func setData(data: MyPray) {
        self.groupIndividualPray = data
        var items = [TableItem]()
        items.append(TableItem(type: .pray,
                               date: data.createDate,
                               content: data.pray))
        for change in data.changes {
            items.append(TableItem(type: .change, date: change.date, content: change.content))
        }
        for answer in data.answers {
            items.append(TableItem(type: .answer, date: answer.date, content: answer.answer))
        }
        items.sort { $0.date < $1.date }
        
        itemList.accept(items)
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
