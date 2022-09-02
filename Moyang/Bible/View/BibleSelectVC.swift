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

class BibleSelectVC: UIViewController, VCType, UICollectionViewDelegateFlowLayout {
    typealias VM = BibleSelectVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?

    // MARK: - UI
    let bookCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BookSelectCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
    let chapterCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BookSelectCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
    let verseCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BookSelectCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
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
        setupBookCV()
        setupChapterCV()
        setupVerseCV()
        setupConfirmButton()
    }
    private func setupBookCV() {
        view.addSubview(bookCV)
        bookCV.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    private func setupChapterCV() {
        view.addSubview(chapterCV)
        chapterCV.snp.makeConstraints {
            $0.top.equalTo(bookCV.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    private func setupVerseCV() {
        view.addSubview(verseCV)
        verseCV.snp.makeConstraints {
            $0.top.equalTo(chapterCV.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    private func setupConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(28)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
        let input = VM.Input()
        let output = vm.transform(input: input)
        output.books
            .drive(bookCV.rx
                .items(cellIdentifier: "cell", cellType: BookSelectCVCell.self)) { [weak self] (_, item, cell) in
                    
                }.disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}
