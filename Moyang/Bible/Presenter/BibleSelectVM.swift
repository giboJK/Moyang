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
    let useCase: PrayUseCase
    
    let books = BehaviorRelay<[BibleItem]>(value: [])
    let chapters = BehaviorRelay<[BibleItem]>(value: [])
    let verses = BehaviorRelay<[BibleItem]>(value: [])
    let selected = BehaviorRelay<[SelectedBibleVerse]>(value: [])
    
    var selectedBookNo = 0
    var selectedChapterNo = 0

    init(useCase: PrayUseCase) {
        self.useCase = useCase
        setupAllBooks()
    }

    deinit { Log.i(self) }
    
    private func setupAllBooks() {
        var list = [BibleItem]()
        list.append(contentsOf: BibleInfo.Old.allCases.map { BibleItem($0.bookName, false) })
        list.append(contentsOf: BibleInfo.New.allCases.map { BibleItem($0.bookName, false) })
        books.accept(list)
        selectGenesis()
    }
    
    private func selectGenesis() {
        selectBook(bookNo: 0)
        selectChapter(chapterNo: 0)
    }
    
    private func selectBook(bookNo: Int) {
        selectedBookNo = bookNo
        var curChapters = [BibleItem]()
        
        for i in 0...BibleInfo.books[bookNo].chapterCount.count {
            curChapters.append(BibleItem("\(i + 1)", false))
        }
        chapters.accept(curChapters)
        verses.accept([])
    }
    
    private func selectChapter(chapterNo: Int) {
        selectedChapterNo = chapterNo
        var curVerses = [BibleItem]()
        
        for i in 0...BibleInfo.books[selectedBookNo].chapterCount[chapterNo] {
            curVerses.append(BibleItem("\(i + 1)", false))
        }
        verses.accept(curVerses)
    }
    
    private func selectVerses(verseNo: Int) {
        checkNearByVerses()
    }
    private func checkNearByVerses() {
        
    }
}

extension BibleSelectVM {
    struct Input {
        var selectBook: Driver<IndexPath> = .empty()
        var selectChapter: Driver<IndexPath> = .empty()
        var selectVerse: Driver<IndexPath> = .empty()
        var deleteVerse: Driver<IndexPath?> = .empty()
    }

    struct Output {
        let books: Driver<[BibleItem]>
        let chapters: Driver<[BibleItem]>
        let verses: Driver<[BibleItem]>
        let selected: Driver<[SelectedBibleVerse]>
    }

    func transform(input: Input) -> Output {
        input.selectBook
            .drive(onNext: { [weak self] indexPath in
                self?.selectBook(bookNo: indexPath.row)
            }).disposed(by: disposeBag)
        
        input.selectChapter
            .drive(onNext: { [weak self] indexPath in
                self?.selectChapter(chapterNo: indexPath.row)
            }).disposed(by: disposeBag)
        
        input.selectVerse
            .drive(onNext: { [weak self] indexPath in
                self?.selectVerses(verseNo: indexPath.row)
            }).disposed(by: disposeBag)
        
        return Output(
            books: books.asDriver(),
            chapters: chapters.asDriver(),
            verses: verses.asDriver(),
            selected: selected.asDriver()
        )
    }
    
    struct BibleItem {
        let content: String
        var isSelected: Bool
        
        init(_ content: String, _ isSelected: Bool) {
            self.content = content
            self.isSelected = isSelected
        }
    }
    
    struct SelectedBibleVerse {
        let bookNo: Int
        let chapter: Int
        let verse: Int
        
        init(_ bookNo: Int,
             _ chapter: Int,
             _ verse: Int) {
            self.bookNo = bookNo
            self.chapter = chapter
            self.verse = verse
        }
    }
}
