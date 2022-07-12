//
//  SignUpVC.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class SignUpVC: UIViewController, VCType {
    typealias VM = SignUpVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: SignUpVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
    let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .nightSky3
    }
    let emailTextField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep1
        $0.layer.borderColor = .nightSky3
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 12
        $0.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [.foregroundColor: UIColor.nightSky3])
        $0.keyboardType = .emailAddress
        $0.returnKeyType = .done
    }
    let invalidEmailFormatLabel = UILabel().then {
        $0.text = "올바른 이메일 형식이 아닙니다"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .appleRed1
        $0.isHidden = true
    }
    let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .nightSky3
    }
    let passwordTextField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep1
        $0.layer.borderColor = .nightSky3
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 12
        $0.isSecureTextEntry = true
        $0.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [.foregroundColor: UIColor.nightSky3])
        $0.returnKeyType = .done
    }
    let passwordMinCountLabel = UILabel().then {
        $0.text = "비밀번호는 최소 6자 이상입니다"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky2
    }
    let confirmButton = MoyangButton(style: .primary).then {
        $0.setTitle("확인", for: .normal)
        $0.isEnabled = false
    }
    let emailExistPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .primary, secondButtonStyle: .ghost).then {
        $0.title = "이미 가입된 이메일"
        $0.desc = "같은 계정으로 가입된 메일이 있습니다. 로그인해주세요"
        $0.firstButton.setTitle("로그인하기", for: .normal)
        $0.secondButton.setTitle("확인", for: .normal)
    }
    let confirmPopup = MoyangPopupView(style: .oneButton).then {
        $0.title = "이메일 전송 성공"
        $0.desc = "이메일을 확인해주세요."
        $0.firstButton.setTitle("확인", for: .normal)
    }
    let confirmFailedPopup = MoyangPopupView(style: .oneButton).then {
        $0.title = "이메일 전송 실패"
        $0.desc = "이메일 전송에 실패하였습니다. 다시 시도해주세요."
        $0.firstButton.setTitle("확인", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        view.backgroundColor = .sheep2
        setupNavBar()
        setupConfirmButton()
        setupEmailLabel()
        setupEmailTextField()
        setupInvalidEmailFormatLabel()
        setupPasswordLabel()
        setupPasswordTextField()
        setupPasswordMinCountLabel()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    private func setupEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(32)
            $0.top.equalTo(navBar.snp.bottom).offset(32)
        }
    }
    private func setupEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
        }
    }
    private func setupInvalidEmailFormatLabel() {
        view.addSubview(invalidEmailFormatLabel)
        invalidEmailFormatLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(12)
            $0.left.equalTo(emailTextField)
            $0.height.equalTo(0)
        }
    }
    private func setupPasswordLabel() {
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(invalidEmailFormatLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(32)
        }
    }
    private func setupPasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
        }
    }
    private func setupPasswordMinCountLabel() {
        view.addSubview(passwordMinCountLabel)
        passwordMinCountLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(12)
            $0.left.equalTo(passwordTextField)
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        emailExistPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup(completion: {
                    self?.coordinator?.moveToLogin()
                })
            }).disposed(by: disposeBag)
        
        emailExistPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setEmail: emailTextField.rx.text.asDriver(),
                             setPassword: passwordTextField.rx.text.asDriver(),
                             checkExist: confirmButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.email
            .drive(emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.password
            .drive(passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isValidEmail
            .skip(1)
            .drive(onNext: { [weak self] isValidEmail in
                guard let self = self else { return }
                self.invalidEmailFormatLabel.isHidden = isValidEmail
                self.invalidEmailFormatLabel.snp.remakeConstraints {
                    $0.top.equalTo(self.emailTextField.snp.bottom).offset(12)
                    $0.left.equalTo(self.passwordTextField)
                    if isValidEmail {
                        $0.height.equalTo(0)
                    } else {
                        $0.height.equalTo(20)
                    }
                }
            }).disposed(by: disposeBag)
        
        output.isAlreadyExist
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.emailExistPopup)
            }).disposed(by: disposeBag)
        
        Driver.combineLatest(output.isValidEmail,
                             output.isValidPassword)
        .map { $0 && $1 }
        .drive(confirmButton.rx.isEnabled)
        .disposed(by: disposeBag)

        output.noUserExist
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let signUpVM = self?.vm else { return }
                self?.coordinator?.noUserExist(vm: signUpVM)
            }).disposed(by: disposeBag)
    }
}

protocol SignUpVCDelegate: AnyObject {
    func noUserExist(vm: SignUpVM)
    func moveToLogin()
}
