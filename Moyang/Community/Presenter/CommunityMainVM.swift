//
//  CommunityMainVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/05.
//

import RxSwift
import RxCocoa

class CommunityMainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension CommunityMainVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
