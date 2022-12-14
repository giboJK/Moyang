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
    private let hasNew = BehaviorRelay<Bool>(value: false)
    private let hasJoinEvent = BehaviorRelay<Bool>(value: false)
    
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
        
        groupList
            .subscribe(onNext: { [weak self] list in
                if list.isEmpty { return }
                var hasJoinEvent = false
                var hasNew = false
                
                list.forEach { item in
                    hasJoinEvent = hasJoinEvent || (item.hasJoinEvent ?? false)
                    hasNew = hasNew || (item.hasNew ?? false)
                }
                self?.hasJoinEvent.accept(hasJoinEvent)
                self?.hasNew.accept(hasNew)
            }).disposed(by: disposeBag)
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
        let hasJoinEvent: Driver<Bool>
        let hasNew: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        input.selectGroup
            .drive(onNext: { [weak self] index in
                self?.createDetailVM(index: index.row)
            }).disposed(by: disposeBag)
        
        return Output(groupList: groupList.asDriver(),
                      detailVM: detailVM.asDriver(),
                      hasJoinEvent: hasJoinEvent.asDriver(),
                      hasNew: hasNew.asDriver()
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
        let hasJoinEvent: Bool?
        let hasNew: Bool?
        
        init(data: GroupMediatorInfo) {
            id = data.id
            name = data.name
            desc = data.desc
            hasJoinEvent = data.hasJoinEvent
            hasNew = data.hasNew
            
            if let userName = data.prayName, let date = data.eventDate {
                prayUser = userName + "님의 중보기도 요청이 있어요"
                eventDate = date.isoToDateString("yyyy.M.d.") ?? ""
            } else {
                prayUser = "중보기도를 요청해보세요 :)"
                eventDate = nil
            }
        }
    }
}
