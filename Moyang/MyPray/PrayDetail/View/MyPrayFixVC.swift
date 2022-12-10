//
//  MyPrayFixVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/21.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MyPrayFixVC: UIViewController, VCType {
    typealias VM = MyPrayDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?

    // MARK: - UI
    let textView = MoyangTextView(.sheep, padding: UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 36))
    let placeholder = MoyangLabel().then {
        $0.text = "내용을 입력하세요"
        $0.font = .b03
        $0.textColor = .sheep3
    }
    let saveButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("수정하기", for: .normal)
    }
    
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
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
        NotificationCenter.default.post(name: NSNotification.Name.MyPrayDetailVCKeyboard,
                                        object: nil, userInfo: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.7) {
                self.saveButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
                        .inset(keyboardSize.height-8)
                }
            }
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        saveButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        view.frame.origin.y = 0
        view.layoutIfNeeded()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    func setupUI() {
        view.backgroundColor = .nightSky4
        setupSaveButton()
        setupTextView()
        setupPlaceholder()
        setupIndicator()
    }
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(28)
        }
    }
    private func setupTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            $0.left.right.equalToSuperview().inset(28)
            $0.bottom.equalTo(saveButton.snp.top).offset(-20)
        }
    }
    private func setupPlaceholder() {
        view.addSubview(placeholder)
        placeholder.snp.makeConstraints {
            $0.top.equalTo(textView).inset(8)
            $0.left.equalTo(textView).inset(8)
        }
    }
    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
        }
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
        let input = VM.Input(setChange: textView.rx.text.asDriver(),
                             saveChange: saveButton.rx.tap.asDriver()
        )
        let output = vm.transform(input: input)
        
        output.isNetworking
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isNetworking in
                if isNetworking {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
        
        output.contentToChange
            .distinctUntilChanged()
            .drive(textView.rx.text)
            .disposed(by: disposeBag)
        
        output.contentToChange.map { $0?.isEmpty ?? true }
            .map { !$0 }
            .drive(placeholder.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.contentToChange.map { $0?.isEmpty ?? true }
            .map { !$0 }
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.updatePraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.updatePrayFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.updateChangeSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.updateChangeFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.updateAnswerSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.updateAnswerFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
    }
}
