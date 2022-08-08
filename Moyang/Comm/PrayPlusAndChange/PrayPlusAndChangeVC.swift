//
//  PrayPlusAndChangeVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class PrayPlusAndChangeVC: UIViewController, VCType, UITextFieldDelegate {
    typealias VM = PrayPlusAndChangeVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    private var tagList = [String]()

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.title = "같이 기도하기"
        $0.closeButton.isHidden = true
        $0.backButton.tintColor = .nightSky1
    }
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.nightSky2, for: .normal)
        $0.setTitleColor(.sheep4, for: .disabled)
    }
    let replyTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let replyHintLabel = UILabel().then {
        $0.text = "기도문을 적어보세요."
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
            if (UIScreen.main.bounds.height - keyboardSize.height) < replyTextView.frame.maxY {
                let diff = replyTextView.frame.maxY - UIScreen.main.bounds.height + keyboardSize.height
                let height = replyTextView.frame.height - diff
                
                replyTextView.snp.updateConstraints {
                    $0.height.equalTo(height - 8)
                }
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        replyTextView.snp.updateConstraints {
            $0.height.equalTo(300)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .sheep2
        setupNavBar()
        setupReplyTextField()
        setupReplyHintLabel()
    }
    
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
        setupSaveButton()
    }
    private func setupSaveButton() {
        navBar.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }
    private func setupReplyTextField() {
        view.addSubview(replyTextView)
        replyTextView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(200)
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
        replyTextView.inputAccessoryView = toolBar
    }
    private func setupReplyHintLabel() {
        view.addSubview(replyHintLabel)
        replyHintLabel.snp.makeConstraints {
            $0.left.equalTo(replyTextView).inset(4)
            $0.top.equalTo(replyTextView).inset(8)
        }
    }
    
    @objc func didTapDoneButton() {
        view.endEditing(true)
    }
    
    // MARK: - Binding
    func bind() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        bindVM()
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setReply: replyTextView.rx.text.asDriver(),
                             saveReply: saveButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.title
            .drive(navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.reply
            .map { $0?.isEmpty ?? true }
            .map { !$0 }
            .drive(replyHintLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.addingReplySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.addingReplyFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}
