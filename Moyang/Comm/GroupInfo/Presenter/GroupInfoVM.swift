//
//  GroupInfoVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/10.
//

import RxSwift
import RxCocoa

class GroupInfoVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    
    let pastorInCharge = BehaviorRelay<String>(value: "")
    let groupStartDate = BehaviorRelay<String>(value: "")
    let memberList = BehaviorRelay<[String]>(value: [])

    init() {
        guard let groupInfo = UserData.shared.groupInfo else { Log.e(""); return }
        if let pastor = groupInfo.pastorInCharge {
            pastorInCharge.accept(pastor.name)
        }
        groupStartDate.accept(groupInfo.createdDate)
        memberList.accept(groupInfo.memberList.map({ $0.name }))
    }

    deinit { Log.i(self) }
}

extension GroupInfoVM {
    struct Input {

    }

    struct Output {
        let pastorInCharge: Driver<String>
        let groupStartDate: Driver<String>
        let memberList: Driver<[String]>
    }

    func transform(input: Input) -> Output {
        return Output(pastorInCharge: pastorInCharge.asDriver(),
                      groupStartDate: groupStartDate.asDriver(),
                      memberList: memberList.asDriver()
        )
    }
}
