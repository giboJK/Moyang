//
//  NewPrayVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/01.
//

import RxSwift
import RxCocoa

class NewPrayVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    let useCase: MyPrayUseCase
    private var currentStep = NewPrayStep.title
    
    let guide = BehaviorRelay<String>(value: "")
    let isSaveEnabled = BehaviorRelay<Bool>(value: false)
    
    let askingAuto = BehaviorRelay<Void>(value: ())
    let setTitleFinish = BehaviorRelay<Void>(value: ())
    let setContentFinish = BehaviorRelay<Void>(value: ())
    let setGroupFinish = BehaviorRelay<Void>(value: ())
    
    let title = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    let group = BehaviorRelay<String?>(value: nil)
    let groupList = BehaviorRelay<[GroupInfo]>(value: [])
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    let addingNewPrayFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: MyPrayUseCase) {
        self.useCase = useCase
        bind()
        setupInitialData()
        fetchMyGroupList()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.isNetworking
            .bind(to: isNetworking)
            .disposed(by: disposeBag)
        
        useCase.addNewPraySuccess
            .skip(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.clearAutoSave()
                self?.changeCurrentStep(.pray)
            }).disposed(by: disposeBag)
        
        useCase.addNewPrayFailure
            .bind(to: addingNewPrayFailure)
            .disposed(by: disposeBag)
        
        // MARK: - Data
        useCase.myGroupList
            .subscribe(onNext: { [weak self] list in
                self?.groupList.accept(list.map { GroupInfo(data: $0) })
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(title, content, group)
            .subscribe(onNext: { [weak self] (title, content, group) in
                var isSaveDisable = title?.isEmpty ?? true
                isSaveDisable = isSaveDisable || content?.isEmpty ?? true
                isSaveDisable = isSaveDisable || group?.isEmpty ?? true
                self?.isSaveEnabled.accept(!isSaveDisable)
                if !isSaveDisable {
                    self?.changeCurrentStep(.save)
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchMyGroupList() {
        useCase.fetchMyGroupList()
    }
    
    private func setupInitialData() {
        guide.accept(NewPrayStep.title.guide)
    }
    
    private func autoSave() {
        if let title = title.value {
            UserData.shared.autoSavedPrayTitle = title.isEmpty ? nil : title
        }
        if let content = content.value {
            UserData.shared.autoSavedPrayContent = content.isEmpty ? nil : content
        }
    }
    
    private func loadAutoSave() {
        Log.d(UserData.shared.autoSavedPrayTitle)
        Log.d(UserData.shared.autoSavedPrayContent)
        if UserData.shared.autoSavedPrayTitle != nil || UserData.shared.autoSavedPrayContent != nil {
            askingAuto.accept(())
        }
    }
    
    private func clearAutoSave() {
        UserData.shared.clearAutoSave()
    }
    
    private func restoreAutoSave() {
        if let content = UserData.shared.autoSavedPrayContent {
            self.content.accept(content)
            if let title = UserData.shared.autoSavedPrayTitle {
                self.title.accept(title)
                changeCurrentStep(.content)
                changeCurrentStep(.group)
            }
        } else {
            if let title = UserData.shared.autoSavedPrayTitle {
                self.title.accept(title)
                changeCurrentStep(.content)
            }
        }
    }
    
    private func addNewPray() {
        guard let title = title.value, let content = content.value else {
            Log.e("No data")
            addingNewPrayFailure.accept(())
            return
        }
        useCase.addPray(title: title, content: content)
        
        if let groupName = group.value {
            sharePray()
        }
    }
    
    private func sharePray() {
        
    }
    
    private func changeCurrentStep(_ step: NewPrayStep) {
        if currentStep == step {
            return
        }
        currentStep = step
        guide.accept(step.guide)
        switch step {
        case .title:
            break
        case .content:
            setTitleFinish.accept(())
        case .group:
            setContentFinish.accept(())
        case .save:
            break
        case .pray:
            break
        }
    }
}

extension NewPrayVM {
    struct Input {
        let setTitle: Driver<String?>
        let endTitleEditing: Driver<Void>
        
        let setContent: Driver<String?>
        let endContentEditing: Driver<Void>
        
        let setGroup: Driver<String?>
        let clearGroup: Driver<Void>
        
        let saveNewPray: Driver<Void>
        
        let loadAutoPray: Driver<Bool>
        let restoreAuto: Driver<Void>
    }

    struct Output {
        let guide: Driver<String>
        let isSaveEnabled: Driver<Bool>
        
        // MARK: - User Events
        let askingAuto: Driver<Void>
        let setTitleFinish: Driver<Void>
        let setContentFinish: Driver<Void>
        let setGroupFinish: Driver<Void>
        
        // MARK: - Data
        let title: Driver<String?>
        let content: Driver<String?>
        let group: Driver<String?>
        let groupList: Driver<[GroupInfo]>
        
        // MARK: - Network Events
        let isNetworking: Driver<Bool>
        let addingNewPrayFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        // MARK: - Title
        input.setTitle
            .drive(title)
            .disposed(by: disposeBag)
        
        input.setTitle.skip(1)
            .drive(onNext: { [weak self] _ in
                self?.autoSave()
            }).disposed(by: disposeBag)

        input.endTitleEditing
            .drive(onNext: { [weak self] _ in
                self?.changeCurrentStep(.content)
            }).disposed(by: disposeBag)
        
        // MARK: - Content
        input.setContent
            .drive(content)
            .disposed(by: disposeBag)
        
        input.setContent.skip(1)
            .drive(onNext: { [weak self] _ in
                self?.autoSave()
            }).disposed(by: disposeBag)
        
        input.endContentEditing
            .drive(onNext: { [weak self] _ in
                self?.changeCurrentStep(.group)
            }).disposed(by: disposeBag)
        
        input.setGroup
            .drive(group)
            .disposed(by: disposeBag)
        
        input.clearGroup.map { nil }
            .drive(group)
            .disposed(by: disposeBag)
        
        input.saveNewPray
            .drive(onNext: { [weak self] _ in
                self?.addNewPray()
            }).disposed(by: disposeBag)
        
        input.loadAutoPray
            .drive(onNext: { [weak self] willBeAppeared in
                if willBeAppeared {
                    self?.loadAutoSave()
                }
            }).disposed(by: disposeBag)
        
        input.restoreAuto
            .drive(onNext: { [weak self] _ in
                self?.restoreAutoSave()
            }).disposed(by: disposeBag)
        
        return Output(guide: guide.asDriver(),
                      isSaveEnabled: isSaveEnabled.asDriver(),
                      
                      askingAuto: askingAuto.asDriver(),
                      setTitleFinish: setTitleFinish.asDriver(),
                      setContentFinish: setContentFinish.asDriver(),
                      setGroupFinish: setGroupFinish.asDriver(),
                      
                      title: title.asDriver(),
                      content: content.asDriver(),
                      group: group.asDriver(),
                      groupList: groupList.asDriver(),
                      
                      isNetworking: isNetworking.asDriver(),
                      addingNewPrayFailure: addingNewPrayFailure.asDriver()
        )
    }
    
    struct GroupInfo {
        let id: String
        let name: String
        
        init(data: MyGroup) {
            id = data.id
            name = data.name
        }
        
        init(id: String, name: String) {
            self.id = id
            self.name = name
        }
    }
    
    private enum NewPrayStep {
        case title
        case content
        case group
        case save
        case pray
        
        var guide: String {
            switch self {
            case .title:
                return "제목을 적어주세요"
            case .content:
                return "내용을 적어주세요"
            case .group:
                return "공유할래요?"
            case .save:
                return "기도를 저장할까요?"
            case .pray:
                return "지금 바로 기도 할 수 있어요"
            }
        }
    }
}
