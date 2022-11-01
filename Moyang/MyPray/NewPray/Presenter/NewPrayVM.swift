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
    let isTitleStep = BehaviorRelay<Bool>(value: true)
    let isContentStep = BehaviorRelay<Bool>(value: false)
    let isGroupStep = BehaviorRelay<Bool>(value: false)
    let isPrayStep = BehaviorRelay<Bool>(value: false)
    let isSaveEnabled = BehaviorRelay<Bool>(value: false)
    
    
    let title = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    let group = BehaviorRelay<String?>(value: nil)

    
    let addingNewPraySuccess = BehaviorRelay<Void>(value: ())
    let addingNewPrayFailure = BehaviorRelay<Void>(value: ())
    
    init(useCase: MyPrayUseCase) {
        self.useCase = useCase
        bind()
        setupData()
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
    }
    
    private func setupData() {
        guide.accept(NewPrayStep.title.guide)
    }
    
    private func autoSave() {
        UserData.shared.autoSavedPray = content.value
    }
    
    private func loadAutoSave() {
        if let autoSavedPray = UserData.shared.autoSavedPray {
            content.accept(autoSavedPray)
        }
    }
    
    private func clearAutoSave() {
        UserData.shared.clearAutoSave()
    }
    
    private func addNewPray() {
        guard let pray = content.value else { Log.e(""); return }
//        useCase.addPray(pray: pray, tags: tagList.value, isSecret: isSecret.value)
    }
    
    private func changeCurrentStep(_ step: NewPrayStep) {
        currentStep = step
        isTitleStep.accept(step == .title)
        isContentStep.accept(step == .content)
        isGroupStep.accept(step == .group)
        isPrayStep.accept(step == .pray)
        guide.accept(step.guide)
    }
}

extension NewPrayVM {
    struct Input {
        let setTitle: Driver<String?>
        let startTitleEditing: Driver<Void>
        let endTitleEditing: Driver<Void>
        var setContent: Driver<String?> = .empty()
        
        var saveNewPray: Driver<Void> = .empty()
        
        var loadAutoPray: Driver<Bool> = .empty()
    }

    struct Output {
        let guide: Driver<String>
        let isTitleStep: Driver<Bool>
        let isContentStep: Driver<Bool>
        let isGroupStep: Driver<Bool>
        let isPrayStep: Driver<Bool>
        let isSaveEnabled: Driver<Bool>
        
        // MARK: - Data
        let title: Driver<String?>
        let content: Driver<String?>
        let group: Driver<String?>
        
        // MARK: - Event
        let addingNewPraySuccess: Driver<Void>
        let addingNewPrayFailure: Driver<Void>
    }

    func transform(input: Input) -> Output {
        input.setTitle
            .drive(title)
            .disposed(by: disposeBag)
        input.startTitleEditing
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.changeCurrentStep(.title)
            }).disposed(by: disposeBag)

        input.endTitleEditing
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.changeCurrentStep(.content)
            }).disposed(by: disposeBag)
        
        input.setContent
            .drive(content)
            .disposed(by: disposeBag)
        
        input.setContent
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.autoSave()
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
                      isTitleStep: isTitleStep.asDriver(),
                      isContentStep: isContentStep.asDriver(),
                      isGroupStep: isGroupStep.asDriver(),
                      isPrayStep: isPrayStep.asDriver(),
                      isSaveEnabled: isSaveEnabled.asDriver(),
                      
                      title: title.asDriver(),
                      content: content.asDriver(),
                      group: group.asDriver(),
                      
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
