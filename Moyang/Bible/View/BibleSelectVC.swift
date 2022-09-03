//
//  BibleSelectVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/23.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class BibleSelectVC: UIViewController, VCType {
    typealias VM = BibleSelectVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    // MARK: - UI
    let selectedVersesCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BibleVerseCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
    let bookTV = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(BookSelectTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = 44
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let chapterTV = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(BookSelectTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = 44
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let verseTV = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(BookSelectTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = 44
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let bookChapterDivider = UIView().then {
        $0.backgroundColor = .sheep4.withAlphaComponent(0.6)
    }
    let chapterVerseDivider = UIView().then {
        $0.backgroundColor = .sheep4.withAlphaComponent(0.6)
    }
    
    let confirmButton = MoyangButton(.primary).then {
        $0.setTitle("완료", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        view.backgroundColor = .nightSky1
        title = "성경 구절"
        setupBookTV()
        setupChapterTV()
        setupVerseTV()
        setupConfirmButton()
    }
    private func setupBookTV() {
        view.addSubview(bookTV)
        bookTV.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(36)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(72)
            $0.width.equalToSuperview().dividedBy(2)
        }
    }
    private func setupChapterTV() {
        view.addSubview(chapterTV)
        chapterTV.snp.makeConstraints {
            $0.top.equalTo(bookTV)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(72)
            $0.left.equalTo(bookTV.snp.right)
            $0.width.equalToSuperview().dividedBy(4)
        }
        view.addSubview(bookChapterDivider)
        bookChapterDivider.snp.makeConstraints {
            $0.top.bottom.right.equalTo(bookTV)
            $0.width.equalTo(1)
        }
    }
    private func setupVerseTV() {
        view.addSubview(verseTV)
        verseTV.snp.makeConstraints {
            $0.top.equalTo(bookTV)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(72)
            $0.left.equalTo(chapterTV.snp.right)
            $0.width.equalToSuperview().dividedBy(4)
        }
        view.addSubview(chapterVerseDivider)
        chapterVerseDivider.snp.makeConstraints {
            $0.top.bottom.right.equalTo(chapterTV)
            $0.width.equalTo(1)
        }
    }
    
    private func setupConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(28)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindVM()
    }
    
    private func bineViews() {
        
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectBook: bookTV.rx.itemSelected.asDriver(),
                             selectChapter: chapterTV.rx.itemSelected.asDriver(),
                             selectVerse: verseTV.rx.itemSelected.asDriver())
        let output = vm.transform(input: input)
        
        output.books
            .drive(bookTV.rx
                .items(cellIdentifier: "cell", cellType: BookSelectTVCell.self)) { (_, item, cell) in
                    cell.contentLabel.text = item.content
                    if item.isSelected {
                        Log.d(item)
                    }
                    cell.setSelected(item.isSelected, animated: true)
                }.disposed(by: disposeBag)
        
        output.chapters
            .drive(chapterTV.rx
                .items(cellIdentifier: "cell", cellType: BookSelectTVCell.self)) { (_, item, cell) in
                    cell.contentLabel.text = item.content
                    cell.setSelected(item.isSelected, animated: true)
                }.disposed(by: disposeBag)
        
        output.verses
            .drive(verseTV.rx
                .items(cellIdentifier: "cell", cellType: BookSelectTVCell.self)) { (_, item, cell) in
                    cell.contentLabel.text = item.content
                    cell.setSelected(item.isSelected, animated: true)
                }.disposed(by: disposeBag)
    }
}
