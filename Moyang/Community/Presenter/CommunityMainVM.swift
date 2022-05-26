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
    let useCase: CommunityMainUseCase
    
    let groupName = BehaviorRelay<String>(value: "")

    init(useCase: CommunityMainUseCase) {
        self.useCase = useCase
        fetchGroupInfo()
        bind()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.groupInfo
            .subscribe(onNext: { [weak self] groupInfo in
                guard let groupInfo = groupInfo else { return }
                self?.setGroupInfoData(data: groupInfo)
            }).disposed(by: disposeBag)
    }
    
    private func fetchGroupInfo() {
        useCase.fetchGroupInfo()
    }
    
    private func setGroupInfoData(data: GroupInfo) {
        Log.w(data)
        groupName.accept(data.groupName)
    }
}

extension CommunityMainVM {
    struct Input {

    }

    struct Output {
        let groupName: Driver<String>
    }

    func transform(input: Input) -> Output {
        return Output(groupName: groupName.asDriver())
    }
}
