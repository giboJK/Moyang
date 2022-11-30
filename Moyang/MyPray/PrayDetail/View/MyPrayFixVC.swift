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
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    func setupUI() {
        setupTextView()
        setupPlaceholder()
        setupSaveButton()
        setupIndicator()
    }
    private func setupTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(220)
        }
    }
    private func setupPlaceholder() {
        view.addSubview(placeholder)
        placeholder.snp.makeConstraints {
            $0.top.equalTo(textView).inset(8)
            $0.left.equalTo(textView).inset(8)
        }
    }
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(24)
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(28)
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
        view.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setChange: textView.rx.text.asDriver(),
                             saveChange: saveButton.rx.tap.asDriver()
        )
        let output = vm.transform(input: input)
        
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
