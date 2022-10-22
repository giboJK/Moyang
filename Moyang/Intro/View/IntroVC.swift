//
//  IntroVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/11.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class IntroVC: UIViewController, VCType {
    typealias VM = IntroVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: IntroVCDelegate?

    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.text = "Moyang"
        $0.font = .systemFont(ofSize: 36, weight: .heavy)
        $0.textColor = .sheep2
    }
    let signUpButton = MoyangButton(.primary).then {
        $0.setTitle("회원가입", for: .normal)
    }
    let loginButton = MoyangButton(.ghost).then {
        $0.setTitle("로그인", for: .normal)
    }
    let versionLabel = UILabel().then {
        $0.textColor = .sheep3
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupTitleLabel()
        setupLoginButton()
        setupSignUpButton()
        setupVersionLabel()
    }
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.5)
        }
    }
    private func setupLoginButton() {
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(76)
        }
    }
    private func setupSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
            $0.bottom.equalTo(loginButton.snp.top).offset(-16)
        }
    }
    private func setupVersionLabel() {
        view.addSubview(versionLabel)
        versionLabel.text = "버전 " + CommonUtils.currentVersion + "." + CommonUtils.currentBuildVersion
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }

    private func bindViews() {
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapSignUpButton()
            }).disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapLogInButton()
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
    }
}

protocol IntroVCDelegate: AnyObject {
    func didTapSignUpButton()
    func didTapLogInButton()
    func didTapPastorLogInButton()
}
