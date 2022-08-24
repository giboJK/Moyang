//
//  BibleSelectVM.swift
//  Moyang
//
//  Created by kibo on 2022/08/24.
//

import RxSwift
import RxCocoa

class BibleSelectVM: VMType {
    var disposeBag: DisposeBag = DisposeBag()
    
    let books = BehaviorRelay<[String]>(value: [])
    let chapters = BehaviorRelay<[String]>(value: [])
    let verses = BehaviorRelay<[String]>(value: [])

    init() {
        setupBooks()
    }

    deinit { Log.i(self) }
    
    private func setupBooks() {
        var list = [String]()
        list.append(contentsOf: BibleInfo.Old.allCases.map { $0.bookName })
        list.append(contentsOf: BibleInfo.New.allCases.map { $0.bookName })
        books.accept(list)
    }
}

extension BibleSelectVM {
    struct Input {

    }

    struct Output {
        let books: Driver<[String]>
        let chapters: Driver<[String]>
        let verses: Driver<[String]>
    }

    func transform(input: Input) -> Output {
        return Output(
            books: books.asDriver(),
            chapters: chapters.asDriver(),
            verses: verses.asDriver()
        )
    }
}
