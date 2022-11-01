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
    
    // MARK: - UI
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
        $0.clipsToBounds = true
        $0.barTintColor = .sheep3
    }
    let guideLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .t04
    }
    let newPrayTitleView = NewPrayTextField("제목", "ex) 진로, 두려움, 감사, OO를 위한 기도")
    let contentTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let groupPrayTitleView = NewPrayTextField("공동체", "").then {
        $0.isHidden = true
    }
    let saveButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("저장하기", for: .normal)
    }
    let cancelButton = MoyangButton(.sheepGhost).then {
        $0.setTitle("취소", for: .normal)
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
        setupGroupPrayTitleView()
        setupContentTextView()
        setupNewPrayTitleView()
        setupCancelButton()
        setupSaveButton()
    }
    private func setupToolbar() {
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: false)
        contentTextView.inputAccessoryView = toolBar
    }
    private func setupGuideLabel() {
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    private func setupGroupPrayTitleView() {
        view.addSubview(groupPrayTitleView)
        groupPrayTitleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(112)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupNewPrayTitleView() {
        view.addSubview(newPrayTitleView)
        newPrayTitleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(112)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func setupContentTextView() {
        view.addSubview(contentTextView)
        contentTextView.inputAccessoryView = toolBar
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
    @objc func didTapDoneButton() {
        view.endEditing(true)
    }
    @objc func didTapCancelButton() {
        view.endEditing(true)
    }
    
    // MARK: - Animation
    private func showContentView() {
        
    }
    private func moveDownTitleView() {
        
    }
    
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setTitle: newPrayTitleView.textField.rx.text.asDriver(),
                             startTitleEditing: newPrayTitleView.textField.rx.controlEvent(.editingDidBegin).asDriver(),
                             endTitleEditing: newPrayTitleView.textField.rx.controlEvent(.editingDidEnd).asDriver(),
                             setContent: contentTextView.rx.text.asDriver(),
                             saveNewPray: saveButton.rx.tap.asDriver(),
                             loadAutoPray: self.rx.viewWillAppear.asDriver(onErrorJustReturn: false))
        
        let output = vm.transform(input: input)
        
        output.guide
            .drive(guideLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isContentStep
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isConstentStep in
                if isConstentStep {
                    self?.moveDownTitleView()
                    self?.showContentView()
                }
            }).disposed(by: disposeBag)
        
        output.isSaveEnabled
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.title.map { $0?.isEmpty ?? true}
            .drive(newPrayTitleView.label.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.content
            .distinctUntilChanged()
            .drive(contentTextView.rx.text)
            .disposed(by: disposeBag)
    }
}
