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
    
    var groupPickerList = ["기본 그룹"]
    
    // MARK: - UI
    let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: NewNoteVC.self, action: #selector(saveTapped))
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
        $0.clipsToBounds = true
        $0.barTintColor = .sheep3
    }
    let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
        $0.clipsToBounds = true
        $0.barTintColor = .sheep3
    }
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    let groupLabel = UILabel().then {
        $0.text = "그룹"
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    let groupTextField = MoyangTextField(.sheep, "그룹 선택")
    let groupPicker = UIPickerView().then {
        $0.backgroundColor = .sheep1
    }
    let titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    let titleTextField = UITextField().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = .sheep3
        $0.layer.borderWidth = 1.5
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .nightSky1
        $0.attributedPlaceholder = NSAttributedString(string: "제목",
                                                      attributes: [.foregroundColor: UIColor.sheep4])
    }
    let pastorLabel = UILabel().then {
        $0.text = "설교자"
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    let pastorTextField = UITextField().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = .sheep3
        $0.layer.borderWidth = 1.5
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .nightSky1
        $0.attributedPlaceholder = NSAttributedString(string: "설교자",
                                                      attributes: [.foregroundColor: UIColor.sheep4])
    }
    let contentLabel = UILabel().then {
        $0.text = "내용"
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    let contentTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = .sheep3
        $0.layer.borderWidth = 1.5
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
    }
    let tagTextField = MoyangTextField(.none, "#태그 추가").then {
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
        return cv
    }()
    
    //    let addBibleButton = UIButton().then {
    //        $0.setTitle("성경 구절+", for: .normal)
    //        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
    //    }
    //    let bibleLabel = UILabel().then {
    //        $0.textColor = .sheep2
    //        $0.font = .systemFont(ofSize: 17, weight: .regular)
    //    }
    
    
    
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
        hideGroupPicker()
        if groupTextField.isFirstResponder || titleTextField.isFirstResponder ||
            pastorTextField.isFirstResponder {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 1.0) {
                self.scrollView.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardSize.height)
                    
                }
            }
        }
        if scrollView.contentOffset.y < 160 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 160), animated: true)
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1.0) {
            self.scrollView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func setupUI() {
        title = "새 예배 노트"
        view.backgroundColor = .nightSky1
        navigationItem.rightBarButtonItems = [saveButton]
        
        setupScrollView()
        setupToolbar()
        setupPickerToolBar()
        
        setupGroupLabel()
        setupGroupTextField()
        
        setupTitleLabel()
        setupTitleTextField()
        setupPastorLabel()
        setupPastorTextField()
        setupContentLabel()
        setupContentTextView()
        setupTagTextField()
        setupTagCollectionView()
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
    private func setupPickerToolBar() {
        let cancelButton = UIBarButtonItem(title: "취소",
                                           style: .plain,
                                           target: self,
                                           action: #selector(didTapCancelButton))
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        pickerToolBar.setItems([cancelButton, space, doneButton], animated: false)
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(250)
        }
    }
    private func setupGroupLabel() {
        scrollView.addSubview(groupLabel)
        groupLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupGroupTextField() {
        scrollView.addSubview(groupTextField)
        groupTextField.snp.makeConstraints {
            $0.top.equalTo(groupLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        groupTextField.leftView = indentView
        groupTextField.leftViewMode = .always
        
        //It will Hide Keyboard
        groupTextField.inputView = UIView()
        //It will Hide Keyboard tool bar
        groupTextField.inputAccessoryView = UIView()
        //It will Hide the cursor
        groupTextField.tintColor = .white
        
        groupPicker.delegate = self
        groupPicker.dataSource = self
        view.addSubview(groupPicker)
        groupPicker.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(290)
            $0.bottom.equalTo(view).offset(290 + 44)
        }
        view.addSubview(pickerToolBar)
        pickerToolBar.snp.makeConstraints {
            $0.bottom.equalTo(groupPicker.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    private func setupTitleLabel() {
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(groupTextField.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupTitleTextField() {
        scrollView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        titleTextField.leftView = indentView
        titleTextField.leftViewMode = .always
        titleTextField.inputAccessoryView = toolBar
    }
    private func setupPastorLabel() {
        scrollView.addSubview(pastorLabel)
        pastorLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupPastorTextField() {
        scrollView.addSubview(pastorTextField)
        pastorTextField.snp.makeConstraints {
            $0.top.equalTo(pastorLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        pastorTextField.leftView = indentView
        pastorTextField.leftViewMode = .always
        pastorTextField.inputAccessoryView = toolBar
    }
    private func setupContentLabel() {
        scrollView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(pastorTextField.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupContentTextView() {
        scrollView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(600)
        }
        contentTextView.inputAccessoryView = toolBar
    }
    private func setupTagTextField() {
        scrollView.addSubview(tagTextField)
        tagTextField.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        tagTextField.delegate = self
        tagTextField.inputAccessoryView = toolBar
    }
    private func setupTagCollectionView() {
        scrollView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.bottom.equalToSuperview()
        }
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagTextField.resignFirstResponder()
        return true
    }
    @objc func didTapDoneButton() {
        view.endEditing(true)
        hideGroupPicker()
    }
    @objc func didTapCancelButton() {
        tagTextField.text?.removeAll()
        view.endEditing(true)
        hideGroupPicker()
    }
    
    func showGroupPicker() {
        groupPicker.snp.updateConstraints {
            $0.bottom.equalTo(view).offset(0)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideGroupPicker() {
        groupPicker.snp.updateConstraints {
            $0.bottom.equalTo(view).offset(290 + 44)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {
        groupTextField.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showGroupPicker()
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(loadAutoNote: self.rx.viewWillAppear.asDriver(onErrorJustReturn: false),
                             setTitle: titleTextField.rx.text.asDriver(),
                             setPastor: pastorTextField.rx.text.asDriver(),
                             setContent: contentTextView.rx.text.asDriver(),
                             setTag: tagTextField.rx.text.asDriver(),
                             
                             addTag: tagTextField.rx.controlEvent(.editingDidEnd).asDriver(),
                             
                             save: saveButton.rx.tap.asDriver()
                             //                             selectBible: addBibleButton.rx.tap.asDriver()
        )
        let output = vm.transform(input: input)
        
        //        output.bibleSelectVM
        //            .drive(onNext: { [weak self] bibleSelectVM in
        //                guard let bibleSelectVM = bibleSelectVM else { return }
        //                self?.openBibleSelectVC(bibleSelectVM: bibleSelectVM)
        //            }).disposed(by: disposeBag)
        
        output.newTitle
            .distinctUntilChanged()
            .drive(titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.newPastor
            .distinctUntilChanged()
            .drive(pastorTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.newContent
            .distinctUntilChanged()
            .drive(contentTextView.rx.text)
            .disposed(by: disposeBag)
        
        
        output.newTag
            .drive(tagTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.tagList
            .drive(onNext: { [weak self] list in
                self?.tagList = list
                self?.tagCollectionView.reloadData()
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

extension NewNoteVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupPickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        switch component {
        case 0:
            attributedString = NSAttributedString(string: groupPickerList[row],
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.nightSky1])
        default:
            attributedString = nil
        }
        return attributedString
    }
}
