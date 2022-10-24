//
//  WorshipNoteVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/15.
//

import RxSwift
import RxCocoa

class WorshipNoteVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    var useCase: WorshipNoteUseCase
    
    let folderList = BehaviorRelay<[NoteCategoryItem]>(value: [])
    
    init(useCase: WorshipNoteUseCase) {
        self.useCase = useCase
        bind()
        fetchCategoryList()
    }

    deinit { Log.i(self) }
    
    private func bind() {
        useCase.categoryList
            .map { list -> [NoteCategoryItem] in
                return list.map { NoteCategoryItem(data: $0) }
            }.bind(to: folderList)
            .disposed(by: disposeBag)
    }
    
    private func fetchCategoryList() {
        useCase.fetchCategoryList()
    }
}

extension WorshipNoteVM {
    struct Input {
        var selelctFolder: Driver<IndexPath> = .empty()
    }

    struct Output {
        let folderList: Driver<[NoteCategoryItem]>
    }

    func transform(input: Input) -> Output {
        return Output(folderList: folderList.asDriver())
    }
    
    struct NoteCategoryItem {
        let id: String
        let name: String
        let color: UIColor
        let createDate: String?
        
        init(data: NoteCategory) {
            self.id = data.id
            self.name = data.name
            switch data.color.lowercased() {
            case "blue":
                self.color = .blue
            case "red":
                self.color = .red
            case "yellow":
                self.color = .yellow
            case "purple":
                self.color = .purple
            case "green":
                self.color = .green
            default:
                self.color = .sheep1
            }
            self.createDate = data.createDate.isoToDateString("yyyy. M. d.")
        }
    }
}
