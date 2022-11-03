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
    let guideLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .t04
    }
    let titleTextView = NewPrayTextField("제목", "ex) 진로, 두려움, 감사, OO를 위한 기도")
    let contentTextView = NewPrayTextView("내용", "내용").then {
        $0.isHidden = true
    }
    let groupTextView = NewPrayTextField("공동체", "").then {
        $0.isHidden = true
    }
    let groupPicker = UIPickerView()
    let saveButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("저장하기", for: .normal)
    }
    let cancelButton = MoyangButton(.sheepGhost).then {
        $0.setTitle("취소", for: .normal)
    }
    let loadAskingPopup = MoyangPopupView(style: .twoButton,
                                          firstButtonStyle: .sheepPrimary,
                                          secondButtonStyle: .sheepGhost).then {
        $0.desc = "작성 중인 기도를 불러오시겠어요"
        $0.firstButton.setTitle("불러오기", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    
    // MARKL - Variables
    var groupList = [String]()
    
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
        setupTitleTextView()
        setupCancelButton()
        setupSaveButton()
    }
    private func setupToolbar() {
        contentDoneButton = UIBarButtonItem(title: "완료",
                                     style: .done,
                                     target: self,
                                     action: nil)
        let contentSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        contentToolBar.setItems([contentSpace, contentDoneButton], animated: false)
        
        groupDoneButton = UIBarButtonItem(title: "완료",
                                          style: .done,
                                          target: self,
                                          action: nil)
        let groupSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        groupToolBar.setItems([groupSpace, groupDoneButton], animated: false)
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
    private func setupTitleTextView() {
        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(-56)
            $0.left.right.equalToSuperview().inset(16)
        }
        titleTextView.textField.becomeFirstResponder()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - Animation
    var isShowContent = false
    var isShowGroup = false
    private func showContentView() {
        if isShowContent { return }
        contentTextView.isHidden = false
        titleTextView.snp.updateConstraints {
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
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setTitle: titleTextView.textField.rx.text.asDriver(),
                             endTitleEditing: titleTextView.textField.rx.controlEvent(.editingDidEnd).asDriver(),
                             setContent: contentTextView.textView.rx.text.asDriver(),
                             endContentEditing: contentDoneButton.rx.tap.asDriver(),
                             setGroup: groupTextView.textField.rx.text.asDriver(),
                             saveNewPray: saveButton.rx.tap.asDriver(),
                             loadAutoPray: self.rx.viewWillAppear.asDriver(onErrorJustReturn: false))
        
        let output = vm.transform(input: input)
        
        output.guide
            .drive(guideLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isSaveEnabled
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
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
        
        output.title.map { $0?.isEmpty ?? true}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isEmpty in
                if isEmpty { return }
                self?.titleTextView.label.isHidden = isEmpty
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
        
        output.groupList.map { list in list.map { $0.name }}
            .drive(onNext: { [weak self] list in
                self?.groupList = list
                self?.groupPicker.reloadAllComponents()
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

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        groupTextView.textField.text = groupList[row]
    }
}
