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

class NewPrayVC: UIViewController, VCType {
    typealias VM = NewPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: NewPrayVCDelegate?
    
    // MARK: - Property
    var groupList = [String]()
    
    // MARK: - UI
    let contentToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
        $0.clipsToBounds = true
        $0.barTintColor = .sheep2
    }
    let groupToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
        $0.clipsToBounds = true
        $0.barTintColor = .sheep2
    }
    var contentDoneButton = UIBarButtonItem()
    var groupDoneButton = UIBarButtonItem()
    var groupCancelButton = UIBarButtonItem()
    let guideLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .t04
    }
    let categoryTextView = NewPrayTextField("카테고리", "ex) 진로, 두려움, 감사, OO를 위한 기도")
    let contentTextView = NewPrayTextView("내용", "내용").then {
        $0.isHidden = true
    }
    let groupTextView = NewPrayTextField("공동체", "", "성령님과 기도할게요 :)").then {
        $0.isHidden = true
    }
    let groupClearButton = MoyangButton(.none).then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .sheep2
    }
    let groupPicker = UIPickerView()
    let saveButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("저장하기", for: .normal)
    }
    let cancelButton = MoyangButton(.sheepGhost).then {
        $0.setTitle("취소", for: .normal)
    }
    let loadAskingPopup = MoyangPopupView(style: .twoButton,
                                          firstButtonStyle: .nightPrimary,
                                          secondButtonStyle: .nightGhost).then {
        $0.desc = "작성 중인 기도를 불러오시겠어요"
        $0.firstButton.setTitle("불러오기", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    let prayContainer = UIView().then { $0.isHidden = true }
    let prayButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    let laterButton = MoyangButton(.sheepSecondary).then {
        $0.setTitle("다음에 할게요", for: .normal)
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        self.view.layoutIfNeeded()
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupToolbar()
        setupGuideLabel()
        setupGroupTextView()
        setupContentTextView()
        setupCategoryTextView()
        setupCancelButton()
        setupSaveButton()
        setupPrayContainer()
        setupIndicator()
    }
    private func setupToolbar() {
        contentDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
        let contentSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        contentToolBar.setItems([contentSpace, contentDoneButton], animated: false)
        
        groupDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
        groupCancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
        let groupSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        groupToolBar.setItems([groupCancelButton, groupSpace, groupDoneButton], animated: false)
    }
    private func setupGuideLabel() {
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    private func setupGroupTextView() {
        view.addSubview(groupTextView)
        groupTextView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(112)
            $0.left.right.equalToSuperview().inset(16)
        }
        setupGroupClearButton()
        
        groupPicker.dataSource = self
        groupPicker.delegate = self
        groupTextView.textField.inputAccessoryView = groupToolBar
        groupTextView.textField.inputView = groupPicker
    }
    private func setupContentTextView() {
        view.addSubview(contentTextView)
        contentTextView.textView.inputAccessoryView = contentToolBar
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(112)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupCategoryTextView() {
        view.addSubview(categoryTextView)
        categoryTextView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(-56)
            $0.left.right.equalToSuperview().inset(16)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            if !self.loadAskingPopup.isHidden {
                return
            }
            self.categoryTextView.textField.becomeFirstResponder()
        }
    }
    
    
    private func setupCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalTo(cancelButton.snp.top).offset(-16)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupGroupClearButton() {
        groupTextView.addSubview(groupClearButton)
        groupClearButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
            $0.size.equalTo(28)
        }
    }
    private func setupPrayContainer() {
        view.addSubview(prayContainer)
        prayContainer.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        prayContainer.addSubview(laterButton)
        laterButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
        prayContainer.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(laterButton.snp.top).offset(-16)
        }
    }
    
    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - Animation
    var isShowContent = false
    var isShowGroup = false
    private func showContentView() {
        if isShowContent { return }
        contentTextView.isHidden = false
        categoryTextView.snp.updateConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(36)
        }
        isShowContent = true
        contentTextView.textView.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.3) {
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    private func showGroupView() {
        if isShowGroup { return }
        groupTextView.isHidden = false
        contentTextView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(201)
        }
        isShowGroup = true
        groupTextView.textField.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.3) {
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        view.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        contentDoneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.contentTextView.textView.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        groupDoneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.groupTextView.textField.resignFirstResponder()
                self.groupTextView.textField.text = self.groupList[self.groupPicker.selectedRow(inComponent: 0)]
                self.groupTextView.textField.sendActions(for: .valueChanged)
            }).disposed(by: disposeBag)
        
        groupCancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.groupTextView.textField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        groupClearButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.groupTextView.textField.text = nil
                self?.groupTextView.textField.sendActions(for: .valueChanged)
            }).disposed(by: disposeBag)
        
        groupTextView.textField.rx.text.map { $0?.isEmpty ?? true }
            .bind(to: groupClearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        laterButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        bindPopup()
    }
    
    
    func bindPopup() {
        loadAskingPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        loadAskingPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
                self?.categoryTextView.textField.becomeFirstResponder()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Bind VM
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setCategory: categoryTextView.textField.rx.text.asDriver(),
                             endCategoryEditing: categoryTextView.textField.rx.controlEvent(.editingDidEndOnExit).asDriver(),
                             setContent: contentTextView.textView.rx.text.asDriver(),
                             endContentEditing: contentDoneButton.rx.tap.asDriver(),
                             setGroup: groupTextView.textField.rx.text.asDriver(),
                             clearGroup: groupClearButton.rx.tap.asDriver(),
                             saveNewPray: saveButton.rx.tap.asDriver(),
                             loadAutoPray: self.rx.viewWillAppear.asDriver(onErrorJustReturn: false),
                             restoreAuto: loadAskingPopup.firstButton.rx.tap.asDriver(),
                             startpraying: prayButton.rx.tap.asDriver())
        
        let output = vm.transform(input: input)
        
        // UI
        output.guide
            .drive(guideLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.title.map { $0?.isEmpty ?? true}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isEmpty in
                if isEmpty { return }
                self?.categoryTextView.label.isHidden = isEmpty
            }).disposed(by: disposeBag)
        
        output.content.map { $0?.isEmpty ?? true}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isEmpty in
                if isEmpty { return }
                self?.contentTextView.label.isHidden = isEmpty
            }).disposed(by: disposeBag)
        
        output.content.map { $0?.isEmpty ?? true }.map { !$0 }
            .distinctUntilChanged()
            .drive(contentTextView.placeholder.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.group.map { $0?.isEmpty ?? true}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isEmpty in
                if isEmpty { return }
                self?.groupTextView.label.isHidden = isEmpty
            }).disposed(by: disposeBag)
        
        // MARK: State
        output.isSaveEnabled
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isNetworking
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isNetworking in
                if isNetworking {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
        
        // MARK: - Event
        output.askingAuto.skip(1)
            .delay(.microseconds(350))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.loadAskingPopup)
            }).disposed(by: disposeBag)
        
        output.setTitleFinish
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.showContentView()
            }).disposed(by: disposeBag)
        
        output.setContentFinish
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.showGroupView()
            }).disposed(by: disposeBag)
        
        output.addPraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.prayContainer.isHidden = false
                self?.saveButton.isHidden = true
                self?.cancelButton.isHidden = true
                self?.groupClearButton.isHidden = true
                self?.groupClearButton.isUserInteractionEnabled = false
                self?.groupTextView.isUserInteractionEnabled = false
                self?.categoryTextView.isUserInteractionEnabled = false
                self?.contentTextView.isUserInteractionEnabled = false
            }).disposed(by: disposeBag)
        
        // MARK: - Data
        output.groupList.map { list in list.map { $0.name }}
            .drive(onNext: { [weak self] list in
                self?.groupList = list
                self?.groupPicker.reloadAllComponents()
            }).disposed(by: disposeBag)
        
        output.title.skip(1)
            .distinctUntilChanged()
            .drive(categoryTextView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.content.skip(1)
            .distinctUntilChanged()
            .drive(contentTextView.textView.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - VM
        output.prayingVM
            .drive(onNext: { [weak self] prayingVM in
                guard let self = self, let prayingVM = prayingVM else { return }
                self.coordinator?.didTapPray(vm: prayingVM)
            }).disposed(by: disposeBag)
    }
}

extension NewPrayVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupList[row]
    }
}

protocol NewPrayVCDelegate: AnyObject {
    func didTapPray(vm: MyPrayPrayingVM)
}
