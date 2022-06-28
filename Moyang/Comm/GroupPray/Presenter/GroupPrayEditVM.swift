//
//  GroupPrayEditVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/28.
//

import RxSwift
import RxCocoa

class GroupPrayEditVM: VMType {
    typealias PrayItem = CommunityMainVM.GroupIndividualPrayItem
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension GroupPrayEditVM {
    struct Input {

    }

    struct Output {
        

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
