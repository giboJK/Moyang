//
//  GroupPrayingVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/05.
//

import RxSwift
import RxCocoa

class GroupPrayingVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: CommunityMainUseCase
    let groupInfo: GroupInfo

    init(useCase: CommunityMainUseCase, groupInfo: GroupInfo) {
        self.useCase = useCase
        self.groupInfo = groupInfo
        bind()
        fetchPray()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        
    }
    
    private func fetchPray() {
        
    }
}

extension GroupPrayingVM {
    struct Input {
        var prevMemberPray: Driver<Void>
        var nextMemberPray: Driver<Void>
    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
    
    struct PrayingItem {
        let id: String
        let memberID: String
        let memberName: String
        let groupID: String
        let date: String
        let pray: String
        let tags: [String]
    }
}
