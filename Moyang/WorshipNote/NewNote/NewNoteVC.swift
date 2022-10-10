//
//  NewNoteVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NewNoteVC: UIViewController, VCType {
    typealias VM = NewNoteVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: NewNoteVCDelegate?
    private var tagList = [String]()

    // MARK: - UI
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.sheep2, for: .normal)
        $0.setTitleColor(.sheep4, for: .disabled)
    }
    let titleTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .nightSky1
    }
    let addBibleButton = UIButton()
    let bibleLabel = UILabel()
    let contentTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.register(NewPrayTagCVCell.self, forCellWithReuseIdentifier: "cell")
    }

    let tagTextField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep3
        $0.layer.cornerRadius = 8
        $0.attributedPlaceholder = NSAttributedString(string: "#태그 추가",
                                                      attributes: [.foregroundColor: UIColor.sheep4])
        $0.textColor = .nightSky1
        $0.returnKeyType = .done
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    func setupUI() {
        title = "새 예배 노트"
        view.backgroundColor = .nightSky1
    }

    // MARK: - Binding
    func bind() {
        bindVM()
    }
    private func bindViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectBible: addBibleButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.bibleSelectVM
            .drive(onNext: { [weak self] bibleSelectVM in
                guard let bibleSelectVM = bibleSelectVM else { return }
                self?.openBibleSelectVC(bibleSelectVM: bibleSelectVM)
            }).disposed(by: disposeBag)
    }
    
    private func openBibleSelectVC(bibleSelectVM: BibleSelectVM) {
        let vc = BibleSelectVC()
        vc.vm = bibleSelectVM
        present(vc, animated: true)
    }
}

protocol NewNoteVCDelegate: AnyObject {

}
