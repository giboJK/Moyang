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
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let guide = BehaviorRelay<String>(value: "")
    let isSaveEnabled = BehaviorRelay<Bool>(value: false)
    
    let setTitleFinish = BehaviorRelay<Void>(value: ())
    let setContentFinish = BehaviorRelay<Void>(value: ())
    let setGroupFinish = BehaviorRelay<Void>(value: ())
    
    let title = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    let group = BehaviorRelay<String?>(value: nil)
    let groupList = BehaviorRelay<[String]>(value: [])

    let addingNewPraySuccess = BehaviorRelay<Void>(value: ())
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
            .bind(to: addingNewPraySuccess)
            .disposed(by: disposeBag)
        
        useCase.addNewPraySuccess
            .skip(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.clearAutoSave()
            }).disposed(by: disposeBag)
        
        useCase.addNewPrayFailure
            .bind(to: addingNewPrayFailure)
            .disposed(by: disposeBag)
        
        // MARK: - Data
        useCase.myGroupList
            .subscribe(onNext: { [weak self] list in
            }).disposed(by: disposeBag)
    }
    
    private func fetchMyGroupList() {
        useCase.fetchMyGroupList()
    }
    
    private func setupInitialData() {
        guide.accept(NewPrayStep.title.guide)
    }
    
    private func autoSave() {
        UserData.shared.autoSavedPrayContent = content.value
    }
    
    private func loadAutoSave() {
        if let title = UserData.shared.autoSavedPrayTitle {
            self.title.accept(title)
        }
        if let content = UserData.shared.autoSavedPrayContent {
            self.content.accept(content)
        }
    }
    
    private func clearAutoSave() {
        UserData.shared.clearAutoSave()
    }
    
    private func addNewPray() {
    }
    
    private func changeCurrentStep(_ step: NewPrayStep) {
        currentStep = step
        guide.accept(step.guide)
        switch step {
        case .title:
            break
        case .content:
            setTitleFinish.accept(())
        case .group:
            setContentFinish.accept(())
        case .pray:
            setGroupFinish.accept(())
        }
    }
}

extension NewPrayVM {
    struct Input {
        let setTitle: Driver<String?>
        let startTitleEditing: Driver<Void>
        let endTitleEditing: Driver<Void>
        
        var setContent: Driver<String?>
        let startContentEditing: Driver<Void>
        let endContentEditing: Driver<Void>
        
        

        var saveNewPray: Driver<Void>
        
        var loadAutoPray: Driver<Bool>
    }

    struct Output {
        let guide: Driver<String>
        let isSaveEnabled: Driver<Bool>
        
        // MARK: - User Events
        let setTitleFinish: Driver<Void>
        let setContentFinish: Driver<Void>
        let setGroupFinish: Driver<Void>
        
        // MARK: - Data
        let title: Driver<String?>
        let content: Driver<String?>
        let group: Driver<String?>
        let groupList: Driver<[String]>
        
        // MARK: - Network Events
        let addingNewPraySuccess: Driver<Void>
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
        
        input.startTitleEditing
            .drive(onNext: { [weak self] _ in
                self?.changeCurrentStep(.title)
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
        
        input.startContentEditing
            .drive(onNext: { [weak self] _ in
                self?.changeCurrentStep(.content)
            }).disposed(by: disposeBag)
        
        input.endContentEditing
            .drive(onNext: { [weak self] _ in
                self?.changeCurrentStep(.group)
            }).disposed(by: disposeBag)
        
        
        
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
        
        return Output(guide: guide.asDriver(),
                      isSaveEnabled: isSaveEnabled.asDriver(),
                      
                      setTitleFinish: setTitleFinish.asDriver(),
                      setContentFinish: setContentFinish.asDriver(),
                      setGroupFinish: setGroupFinish.asDriver(),
                      
                      title: title.asDriver(),
                      content: content.asDriver(),
                      group: group.asDriver(),
                      groupList: groupList.asDriver(),
                      
                      addingNewPraySuccess: addingNewPraySuccess.asDriver(),
                      addingNewPrayFailure: addingNewPrayFailure.asDriver()
        )
    }
    
    private enum NewPrayStep {
        case title
        case content
        case group
        case pray
        
        var guide: String {
            switch self {
            case .title:
                return "제목을 적어주세요"
            case .content:
                return "내용을 적어주세요"
            case .group:
                return "기도를 공유할래요?"
            case .pray:
                return "지금 바로 기도할래요?"
            }
        }
    }
}
