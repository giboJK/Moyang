//
//  NewPrayVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NewPrayVC: UIViewController, VCType, UITextFieldDelegate {
    typealias VM = NewPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    private var tagList = [String]()
    
    // MARK: - UI
    let navBar = MoyangNavBar(.dark).then {
        $0.closeButton.isHidden = true
        $0.backButton.isHidden = true
        $0.title = "새 기도"
    }
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.appleRed1, for: .normal)
    }
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.sheep2, for: .normal)
        $0.setTitleColor(.sheep4, for: .disabled)
    }
    let groupNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep2
    }
    let groupChangeButton = MoyangButton(.none).then {
        $0.setTitle("그룹 변경", for: .normal)
        $0.setTitleColor(.sheep2, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    let newPrayTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let tagInfoLabel = UILabel().then {
        $0.text = "태그는 5개까지 추가되며 하나당 최대 20자입니다."
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep4
        $0.numberOfLines = 0
    }
    let tagTextField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep3
        $0.layer.cornerRadius = 8
        $0.attributedPlaceholder = NSAttributedString(string: "#태그 추가",
                                                      attributes: [.foregroundColor: UIColor.sheep4])
        $0.textColor = .nightSky1
        $0.returnKeyType = .done
    }
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.register(NewPrayTagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    let isSecretLabel = UILabel().then {
        $0.text = "비공개 기도"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep2
    }
    let isSecretCheckBox = CheckBox()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    deinit {
        Log.i(self)
        vm?.clearNewTag()
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupNavBar()
        setupGroupNameLabel()
        setupGroupChangeButton()
        setupNewPrayTextView()
        setupTagInfoLabel()
        setupTagTextField()
        setupTagCollectionView()
        setupIsSecretLabel()
        setupIsSecretCheckBox()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(44)
        }
        setupCancelButton()
        setupSaveButton()
    }
    private func setupCancelButton() {
        navBar.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }
    private func setupSaveButton() {
        navBar.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }
    private func setupGroupNameLabel() {
        view.addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(80)
        }
    }
    private func setupGroupChangeButton() {
        view.addSubview(groupChangeButton)
        groupChangeButton.snp.makeConstraints {
            $0.top.bottom.equalTo(groupNameLabel)
            $0.right.equalToSuperview().inset(16)
        }
    }
    private func setupNewPrayTextView() {
        view.addSubview(newPrayTextView)
        newPrayTextView.snp.makeConstraints {
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(220)
        }
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.barTintColor = .sheep3
        }
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: false)
        newPrayTextView.inputAccessoryView = toolBar
    }
    
    private func setupTagInfoLabel() {
        view.addSubview(tagInfoLabel)
        tagInfoLabel.snp.makeConstraints {
            $0.top.equalTo(newPrayTextView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupTagTextField() {
        view.addSubview(tagTextField)
        tagTextField.snp.makeConstraints {
            $0.top.equalTo(tagInfoLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        tagTextField.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.barTintColor = .sheep3
        }
        let cancelButton = UIBarButtonItem(title: "취소",
                                           style: .plain,
                                         target: self,
                                         action: #selector(didTapCancelButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, space], animated: false)
        tagTextField.inputAccessoryView = toolBar
        
    }
    private func setupTagCollectionView() {
        view.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }
    
    private func setupIsSecretLabel() {
        view.addSubview(isSecretLabel)
        isSecretLabel.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
        }
    }
    private func setupIsSecretCheckBox() {
        view.addSubview(isSecretCheckBox)
        isSecretCheckBox.snp.makeConstraints {
            $0.centerY.equalTo(isSecretLabel)
            $0.left.equalTo(isSecretLabel.snp.right).offset(4)
            $0.size.equalTo(18)
        }
    }
    private func increaseTagCollectionViewHeight(count: Int) {
        let currentHeight = tagCollectionView.bounds.height
        tagCollectionView.snp.updateConstraints {
            $0.height.equalTo(currentHeight + 8 + 32)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
            if self.tagCollectionView.visibleCells.count < count {
                self.increaseTagCollectionViewHeight(count: count)
            }
        }
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
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        tagTextField.rx.controlEvent(.editingDidEnd)
            .delay(.milliseconds(50), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.tagTextField.text?.removeAll()
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setPray: newPrayTextView.rx.text.asDriver(),
                             saveNewPray: saveButton.rx.tap.asDriver(),
                             setTag: tagTextField.rx.text.asDriver(),
                             addTag: tagTextField.rx.controlEvent(.editingDidEnd).asDriver(),
                             loadAutoPray: self.rx.viewWillAppear.asDriver(onErrorJustReturn: false),
                             toggleIsSecret: isSecretCheckBox.rx.tap.asDriver())
        
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(groupNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.newPray
            .map { $0?.isEmpty ?? true }
            .map { !$0 }
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.newPray
            .distinctUntilChanged()
            .drive(newPrayTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.newTag
            .drive(tagTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.tagList
            .map { $0.count < 5 }
            .drive(tagTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.tagList
            .map { $0.count >= 5 }
            .drive(onNext: { [weak self] isFullTag in
                self?.tagTextField.backgroundColor = isFullTag ? .sheep3 : .sheep1
            }).disposed(by: disposeBag)
        
        output.tagList
            .drive(onNext: { [weak self] list in
                self?.tagList = list
                self?.tagCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        output.tagList
            .delay(.milliseconds(50))
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                if self.tagCollectionView.visibleCells.count < list.count {
                    self.increaseTagCollectionViewHeight(count: list.count)
                } else {
                    if !self.tagCollectionView.visibleCells.isEmpty {
                        var maxY: CGFloat = 0
                        self.tagCollectionView.visibleCells.forEach { cell in
                            maxY = max(cell.frame.maxY, maxY)
                        }
                        let currentHeight = self.tagCollectionView.bounds.height
                        if currentHeight - maxY > 8 {
                            self.tagCollectionView.snp.updateConstraints {
                                $0.height.equalTo(currentHeight - 8 - 32)
                            }
                        }
                    } else {
                        self.tagCollectionView.snp.updateConstraints {
                            $0.height.equalTo(0)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        output.isSecret
            .drive(isSecretCheckBox.rx.isChecked)
            .disposed(by: disposeBag)
        
    }
}

extension NewPrayVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tagList[indexPath.row].width(withConstraintedHeight: 16,
                                                       font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + 24 + buttonWidth, height: 32)
    }
}

extension NewPrayVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewPrayTagCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tagList[indexPath.row]
        cell.vm = vm
        cell.indexPath = indexPath
        cell.bind()
        
        return cell
    }
}
