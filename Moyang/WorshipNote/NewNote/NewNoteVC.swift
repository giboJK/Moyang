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

class NewNoteVC: UIViewController, VCType, UITextFieldDelegate {
    typealias VM = NewNoteVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: NewNoteVCDelegate?
    private var tagList = [String]()
    
    // MARK: - UI
    let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: NewNoteVC.self, action: #selector(saveTapped))
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
        $0.clipsToBounds = true
        $0.barTintColor = .sheep3
    }
    let titleTextField = UITextField().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .nightSky1
        $0.attributedPlaceholder = NSAttributedString(string: "설교 제목",
                                                      attributes: [.foregroundColor: UIColor.sheep4])
    }
    let pastorTextField = UITextField().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .nightSky1
        $0.attributedPlaceholder = NSAttributedString(string: "설교자",
                                                      attributes: [.foregroundColor: UIColor.sheep4])
    }
//    let addBibleButton = UIButton().then {
//        $0.setTitle("성경 구절+", for: .normal)
//        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
//    }
//    let bibleLabel = UILabel().then {
//        $0.textColor = .sheep2
//        $0.font = .systemFont(ofSize: 17, weight: .regular)
//    }
    let contentTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let tagTextField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep3
        $0.layer.cornerRadius = 8
        $0.attributedPlaceholder = NSAttributedString(string: "#태그 추가",
                                                      attributes: [.foregroundColor: UIColor.sheep4])
        $0.textColor = .nightSky1
        $0.returnKeyType = .done
    }
    
    let tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(NewNoteTagCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.allowsMultipleSelection = false
        cv.isMultipleTouchEnabled = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 1.0) {
                self.tagCollectionView.snp.remakeConstraints {
                    $0.left.right.equalToSuperview().inset(20)
                    $0.height.equalTo(32)
                    $0.bottom.equalToSuperview().inset(keyboardSize.height + 12)
                }
            }
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1.0) {
            self.tagCollectionView.snp.remakeConstraints {
                $0.left.right.equalToSuperview().inset(20)
                $0.height.equalTo(32)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func setupUI() {
        title = "새 예배 노트"
        view.backgroundColor = .nightSky1
        navigationItem.rightBarButtonItems = [saveButton]
        
        setupToolbar()
        setupTagCollectionView()
        setupTitleTextField()
//        setupAddBibleButton()
//        setupBibleLabel()
        setupPastorTextField()
        setupTagTextField()
        setupContentTextView()
    }
    private func setupToolbar() {
        let cancelButton = UIBarButtonItem(title: "취소",
                                           style: .plain,
                                         target: self,
                                         action: #selector(didTapCancelButton))
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
    }
    
    private func setupTitleTextField() {
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        titleTextField.leftView = indentView
        titleTextField.leftViewMode = .always
        titleTextField.inputAccessoryView = toolBar
    }
//    private func setupAddBibleButton() {
//        view.addSubview(addBibleButton)
//        addBibleButton.snp.makeConstraints {
//            $0.top.equalTo(titleTextField.snp.bottom).offset(8)
//            $0.left.equalToSuperview().inset(20)
//            $0.height.equalTo(28)
//        }
//    }
//    private func setupBibleLabel() {
//        view.addSubview(bibleLabel)
//        bibleLabel.snp.makeConstraints {
//            $0.top.equalTo(titleTextField.snp.bottom).offset(8)
//            $0.left.right.equalToSuperview().inset(20)
//            $0.height.equalTo(28)
//        }
//    }
    private func setupPastorTextField() {
        view.addSubview(pastorTextField)
        pastorTextField.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        pastorTextField.leftView = indentView
        pastorTextField.leftViewMode = .always
        pastorTextField.inputAccessoryView = toolBar
    }
    private func setupTagCollectionView() {
        view.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }
    private func setupTagTextField() {
        view.addSubview(tagTextField)
        tagTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(36)
            $0.bottom.equalTo(tagCollectionView.snp.top).offset(-8)
        }
        tagTextField.delegate = self
        tagTextField.inputAccessoryView = toolBar
    }
    private func setupContentTextView() {
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(pastorTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(tagTextField.snp.top).offset(-8)
        }
        contentTextView.inputAccessoryView = toolBar
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagTextField.resignFirstResponder()
        return true
    }
    @objc func didTapDoneButton() {
        view.endEditing(true)
    }
    @objc func didTapCancelButton() {
        tagTextField.text?.removeAll()
        view.endEditing(true)
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(save: saveButton.rx.tap.asDriver()
//                             selectBible: addBibleButton.rx.tap.asDriver()
        )
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
    
    @objc func saveTapped() {
        
    }
}

extension NewNoteVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tagList[indexPath.row].width(withConstraintedHeight: 16,
                                                       font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + 24 + buttonWidth, height: 32)
    }
}

extension NewNoteVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewNoteTagCVCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tagList[indexPath.row]
        cell.vm = vm
        cell.indexPath = indexPath
        cell.bind()
        
        return cell
    }
}

protocol NewNoteVCDelegate: AnyObject {

}
