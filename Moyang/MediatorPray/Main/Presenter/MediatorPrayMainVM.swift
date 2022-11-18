//
//  MediatorPrayMainVM.swift
//  Moyang
//
//  Created by kibo on 2022/10/24.
//

import RxSwift
import RxCocoa

class MediatorPrayMainVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: GroupUseCase

    // MARK: - Data
    private let groupList = BehaviorRelay<[GroupItem]>(value: [])
    
    // MARK: - VM
    private let detailVM = BehaviorRelay<GroupDetailVM?>(value: nil)
    
    init(useCase: GroupUseCase) {
        self.useCase = useCase
        bind()
        fetchGroupList()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchGroupList),
                                               name: NSNotification.Name.ReloadGroupList, object: nil)
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.myGroupMediatorInfos
            .map({ list in list.map { GroupItem(data: $0) } })
            .bind(to: groupList)
            .disposed(by: disposeBag)
    }
    
    @objc func fetchGroupList() {
        useCase.fetchMyGroupSummary()
    }
    
    private func createDetailVM(index: Int) {
        let selectedGroup = groupList.value[index]
        detailVM.accept(GroupDetailVM(useCase: useCase, groupID: selectedGroup.id))
    }
}

extension MediatorPrayMainVM {
    struct Input {
        let selectGroup: Driver<IndexPath>
    }

    struct Output {
        let groupList: Driver<[GroupItem]>
        let detailVM: Driver<GroupDetailVM?>
    }

    func transform(input: Input) -> Output {
        input.selectGroup
            .drive(onNext: { [weak self] index in
                self?.createDetailVM(index: index.row)
            }).disposed(by: disposeBag)
        
        return Output(groupList: groupList.asDriver(),
                      detailVM: detailVM.asDriver()
        )
    }
}

extension MediatorPrayMainVM {
    struct GroupItem {
        let id: String
        let name: String
        let desc: String
        let prayUser: String?
        let eventDate: String?
        
        init(data: GroupMediatorInfo) {
            id = data.id
            name = data.name
            desc = data.desc
            if let userName = data.prayName, let date = data.eventDate {
                prayUser = userName + "님의 중보기도 요청이 있어요"
                eventDate = date.isoToDateString("yyyy.M.d.") ?? ""
            } else {
                prayUser = nil
                eventDate = nil
            }
        }
    }
}
