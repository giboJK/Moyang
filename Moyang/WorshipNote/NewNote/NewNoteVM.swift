//
//  NewNoteVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import RxSwift
import RxCocoa

class NewNoteVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    var useCase: WorshipNoteUseCase
    var bibleUseCasa: BibleUseCase
    
    let isNetworking = BehaviorRelay<Bool>(value: false)
    
    let bibleSelectVM = BehaviorRelay<BibleSelectVM?>(value: nil)
    
    let newTitle = BehaviorRelay<String?>(value: nil)
    let newPastor = BehaviorRelay<String?>(value: nil)
    let newContent = BehaviorRelay<String?>(value: nil)
    let newTag = BehaviorRelay<String?>(value: nil)
    let tagList = BehaviorRelay<[String]>(value: [])
    
    init(useCase: WorshipNoteUseCase, bibleUseCasa: BibleUseCase) {
        self.useCase = useCase
        self.bibleUseCasa = bibleUseCasa
    }
    
    deinit { Log.i(self) }
    
    private func autoSave() {
        UserData.shared.autoSavedNoteTitle = newTitle.value
        UserData.shared.autoSavedNotePastor = newPastor.value
        UserData.shared.autoSavedNoteContent = newContent.value
        UserData.shared.autoSavedNoteTags = tagList.value
    }
    
    private func loadAutoSave() {
        newTitle.accept(UserData.shared.autoSavedNoteTitle)
        newPastor.accept(UserData.shared.autoSavedNotePastor)
        newContent.accept(UserData.shared.autoSavedNoteContent)
        
        tagList.accept(UserData.shared.autoSavedNoteTags ?? [])
    }
    
    private func saveNote() {
        
    }
}

extension NewNoteVM {
    struct Input {
        var loadAutoNote: Driver<Bool> = .empty()
        
        var setTitle: Driver<String?> = .empty()
        var setPastor: Driver<String?> = .empty()
        var setContent: Driver<String?> = .empty()
        var setTag: Driver<String?> = .empty()
        
        var addTag: Driver<Void> = .empty()
        var deleteTag: Driver<IndexPath?> = .empty()
        
        var save: Driver<Void> = .empty()
        
        var selectBible: Driver<Void> = .empty()
    }
    
    struct Output {
        let newTitle: Driver<String?>
        let newPastor: Driver<String?>
        let newContent: Driver<String?>
        let newTag: Driver<String?>
        let tagList: Driver<[String]>
        
        let bibleSelectVM: Driver<BibleSelectVM?>
    }
    
    func transform(input: Input) -> Output {
        input.loadAutoNote
            .drive(onNext: { [weak self] willBeAppeared in
                if willBeAppeared {
                    self?.loadAutoSave()
                }
            }).disposed(by: disposeBag)
        
        input.save.drive(onNext: { [weak self] _ in
            self?.saveNote()
        }).disposed(by: disposeBag)
        
        input.setTitle
            .skip(1)
            .drive(onNext: { [weak self] title in
                self?.newTitle.accept(title)
                UserData.shared.autoSavedNoteTitle = title
            }).disposed(by: disposeBag)
        
        input.setPastor
            .skip(1)
            .drive(onNext: { [weak self] pastor in
                self?.newPastor.accept(pastor)
                UserData.shared.autoSavedNotePastor = pastor
            }).disposed(by: disposeBag)
        
        input.setContent
            .skip(1)
            .drive(onNext: { [weak self] content in
                self?.newContent.accept(content)
                UserData.shared.autoSavedNoteContent = content
            }).disposed(by: disposeBag)
        
        input.setTag.drive(onNext: { [weak self] tag in
            self?.newTag.accept(tag)
        }).disposed(by: disposeBag)
        
        input.addTag
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                var currnetTags = self.tagList.value
                if let tag = self.newTag.value,
                   !tag.isEmpty, !tag.trimmingCharacters(in: .whitespaces).isEmpty {
                    currnetTags.append(tag)
                    self.tagList.accept(currnetTags)
                    self.newTag.accept(nil)
                    self.autoSave()
                }
            }).disposed(by: disposeBag)
        
        input.deleteTag
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { Log.e(""); return }
                guard let indexPath = indexPath else { Log.e(""); return }
                var currnetTags = self.tagList.value
                if currnetTags.count > indexPath.row {
                    currnetTags.remove(at: indexPath.row)
                    self.tagList.accept(currnetTags)
                    self.autoSave()
                }
            }).disposed(by: disposeBag)
        
        input.selectBible.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.bibleSelectVM.accept(BibleSelectVM(useCase: self.bibleUseCasa))
        }).disposed(by: disposeBag)
        
        return Output(
            newTitle: newTitle.asDriver(),
            newPastor: newPastor.asDriver(),
            newContent: newContent.asDriver(),
            newTag: newTag.asDriver(),
            tagList: tagList.asDriver(),
            
            bibleSelectVM: bibleSelectVM.asDriver())
    }
}
