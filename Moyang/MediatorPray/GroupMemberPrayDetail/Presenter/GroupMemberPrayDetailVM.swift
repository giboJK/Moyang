//
//  GroupMemberPrayDetailVM.swift
//  Moyang
//
//  Created by kibo on 2022/11/23.
//

import RxSwift
import RxCocoa

class GroupMemberPrayDetailVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()

    let useCase: GroupUseCase
    
    // MARK: - State
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    init(useCase: GroupUseCase) {
        self.useCase = useCase
        bind()
    }

    deinit { Log.i(self) }

    private func bind() {
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
    }
    
    func checkCanEdit(indexPath: IndexPath) {
        
    }
    
    func checkCanDelete(indexPath: IndexPath) {
        
    }
}

extension GroupMemberPrayDetailVM {
    struct Input {
    }

    struct Output {
        let isNetworking: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        return Output(isNetworking: isNetworking.asDriver()
        )
    }
}
