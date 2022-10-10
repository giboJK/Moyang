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
    let useCase: BibleUseCase
    
    let books = BehaviorRelay<[BibleItem]>(value: [])
    let chapters = BehaviorRelay<[BibleItem]>(value: [])
    let verses = BehaviorRelay<[BibleItem]>(value: [])
    let selected = BehaviorRelay<[String]>(value: [])
    
    var selectedBookNo = 0
    var selectedChapterNo = 0
    var selectedVerses = [BibleVerse]()

    init(useCase: BibleUseCase) {
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
        
        for i in 0..<BibleInfo.books[bookNo].chapterCount.count {
            curChapters.append(BibleItem("\(i + 1)", false))
        }
        chapters.accept(curChapters)
        verses.accept([])
    }
    
    private func selectChapter(chapterNo: Int) {
        selectedChapterNo = chapterNo
        var curVerses = [BibleItem]()
        
        for i in 0..<BibleInfo.books[selectedBookNo].chapterCount[chapterNo] {
            curVerses.append(BibleItem("\(i + 1)", false))
        }
        verses.accept(curVerses)
    }
    
    private func selectVerses(verseNo: Int) {
        let new = BibleVerse(selectedBookNo, selectedChapterNo, verseNo)
        
        if selectedVerses.contains(where: { $0 == new }) {
            Log.d("Has same")
            return
        } else {
            selectedVerses.append(new)
            generateSelectedString()
        }
    }
    
    private func generateSelectedString() {
        sortingVerses()
        generateStrings()
        Log.d(selectedVerses)
    }
    
    private func deleteVerse(index: Int) {
        selectedVerses.remove(at: index)
        generateSelectedString()
    }
    
    private func sortingVerses() {
        selectedVerses.sort { (lhs: BibleVerse, rhs: BibleVerse) -> Bool in
            if lhs.bookNo > rhs.bookNo {
                return false
            }
            if lhs.bookNo < rhs.bookNo {
                return true
            }
            if lhs.chapter > rhs.chapter {
                return false
            }
            if lhs.chapter < rhs.chapter {
                return true
            }
            if lhs.verse > rhs.verse {
                return false
            }
            return true
        }
    }
    
    private func generateStrings() {
        if selectedVerses.count == 1 {
            selected.accept(selectedVerses.map { $0.content })
            return
        }
        var strList = [String]()
        var str = ""
        var verses = [Int]()
        for i in 0 ..< selectedVerses.count - 1 {
            let cur = selectedVerses[i]
            let next = selectedVerses[i + 1]
            if let old = BibleInfo.Old.init(rawValue: cur.bookNo) {
                str = "\(old.short) \(cur.chapter + 1)장 "
            } else if let new = BibleInfo.New.init(rawValue: cur.bookNo) {
                str = "\(new.short) \(cur.chapter + 1)장 "
            }
            verses.append(cur.verse)
            if !checkIsContinuousVerses(cur: cur, next: next) {
                if verses.count > 1 {
                    str += "\(verses.first! + 1)-\(verses.last! + 1)절"
                } else {
                    str += "\(cur.verse + 1)절"
                }
                strList.append(str)
                str.removeAll()
                verses.removeAll()
            }
        }
        
        if !str.isEmpty {
            if let last = selectedVerses.last {
                verses.append(last.verse)
                str += "\(verses.first! + 1)-\(verses.last! + 1)절"
            }
        } else {
            if let last = selectedVerses.last {
                if let old = BibleInfo.Old.init(rawValue: last.bookNo) {
                    str = "\(old.short) \(last.chapter + 1)장 \(last.verse + 1)절"
                } else if let new = BibleInfo.New.init(rawValue: last.bookNo) {
                    str = "\(new.short) \(last.chapter + 1)장 \(last.verse + 1)절"
                }
            }
        }
        strList.append(str)
        
        selected.accept(strList)
    }
    
    private func checkIsContinuousVerses(cur: BibleVerse, next: BibleVerse) -> Bool {
        if (cur.bookNo == next.bookNo) &&
            (cur.chapter == next.chapter) {
            return (cur.verse + 1) == (next.verse)
        }
        return false
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
        let selected: Driver<[String]>
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
        
        input.deleteVerse
            .drive(onNext: { [weak self] indexPath in
                guard let indexPath = indexPath else { return}
                self?.deleteVerse(index: indexPath.row)
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
}
