//
//  ProfileVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/19.
//

import RxSwift
import RxCocoa

class ProfileVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    deinit { Log.i(self) }
}

extension ProfileVM {
    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
