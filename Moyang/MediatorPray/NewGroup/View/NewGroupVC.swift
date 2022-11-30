//
//  NewGroupVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/15.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NewGroupVC: UIViewController, VCType {
    typealias VM = NewGroupVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: NewGroupVCDelegate?

    // MARK: - UI
    let nameLabel = MoyangLabel().then {
        $0.text = "공동체명"
        $0.textColor = .sheep3
        $0.font = .b03
        $0.textAlignment = .left
    }
    let nameTextField = MoyangTextField(.sheep, "공동체명").then {
        $0.returnKeyType = .done
    }
    let descLabel = MoyangLabel().then {
        $0.text = "소개글"
        $0.textColor = .sheep3
        $0.font = .b03
        $0.textAlignment = .left
    }
    let descTextField = MoyangTextField(.sheep, "소개글").then {
        $0.returnKeyType = .done
    }
    let confirmButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("확인", for: .normal)
    }
    let failurePopup = MoyangPopupView(style: .oneButton, firstButtonStyle: .warning).then {
        $0.desc = "그룹 생성에 실패하였습니다. 개발자에게 문의하세요"
        $0.firstButton.setTitle("확인", for: .normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    func setupUI() {
        title = "새 공동체"
        view.backgroundColor = .nightSky1
        setupNameLabel()
        setupNameTextField()
        setupDescLabel()
        setupDescTextField()
        setupConfirmButton()
        setupIndicator()
    }
    
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(17)
            $0.left.right.equalToSuperview().inset(24)
        }
        
    }
    private func setupNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
    }
    private func setupDescLabel() {
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(36)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupDescTextField() {
        view.addSubview(descTextField)
        descTextField.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
    private func setupConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
    
    func bindViews() {
        failurePopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
    }
    

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setName: nameTextField.rx.text.asDriver(),
                             setDesc: descTextField.rx.text.asDriver(),
                             confirm: confirmButton.rx.tap.asDriver()
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
        
        output.isSaveEnabled
            .drive(confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.name
            .distinctUntilChanged()
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.desc
            .distinctUntilChanged()
            .drive(descTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.registerGroupSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

protocol NewGroupVCDelegate: AnyObject {

}
