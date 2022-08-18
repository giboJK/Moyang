//
//  AddReplyAndChangeVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class AddReplyAndChangeVC: UIViewController, VCType, UITextFieldDelegate {
    typealias VM = AddReplyAndChangeVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    private var tagList = [String]()

    // MARK: - UI
    let saveButton = MoyangButton(.primary).then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.nightSky2, for: .normal)
        $0.setTitleColor(.sheep4, for: .disabled)
    }
    let contentTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let replyHintLabel = UILabel().then {
        $0.text = "내용을 입력하세요."
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep4
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
    
    deinit {
        Log.i(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 1.0) {
                self.saveButton.snp.remakeConstraints {
                    $0.left.right.equalToSuperview().inset(24)
                    $0.height.equalTo(48)
                    $0.bottom.equalToSuperview().inset(keyboardSize.height + 16)
                }
            }
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1.0) {
            self.saveButton.snp.remakeConstraints {
                $0.left.right.equalToSuperview().inset(24)
                $0.height.equalTo(48)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func setupUI() {
        view.backgroundColor = .sheep2
        setupSaveButton()
        setupContentTextField()
        setupContentHintLabel()
    }
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    private func setupContentTextField() {
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(saveButton.snp.top).offset(-16)
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
        contentTextView.inputAccessoryView = toolBar
    }
    private func setupContentHintLabel() {
        view.addSubview(replyHintLabel)
        replyHintLabel.snp.makeConstraints {
            $0.left.equalTo(contentTextView).inset(4)
            $0.top.equalTo(contentTextView).inset(8)
        }
    }
    
    
    @objc func didTapDoneButton() {
        view.endEditing(true)
    }
    
    // MARK: - Binding
    func bind() {
        bindVM()
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setContent: contentTextView.rx.text.asDriver(),
                             saveContent: saveButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.title
            .drive(onNext: { [weak self] title in
                self?.title = title
            }).disposed(by: disposeBag)
        
        output.content
            .map { $0?.isEmpty ?? true }
            .map { !$0 }
            .drive(replyHintLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.content
            .map { $0?.isEmpty ?? true }
            .map { !$0 }
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.plusPraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        output.plusPrayFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        output.addChangeSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.addChangeFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.addReplySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.addReplyFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.addAnswerSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.addAnswerFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
