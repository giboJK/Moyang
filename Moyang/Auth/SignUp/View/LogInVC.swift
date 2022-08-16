//
//  LogInVC.swift
//  Moyang
//
//  Created by kibo on 2022/07/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import AuthenticationServices
import GoogleSignIn

class LogInVC: UIViewController, VCType {
    typealias VM = LogInVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: LogInVCDelegate?
    
    let signInConfig = GIDConfiguration.init(clientID: NetConst.googleClientID)
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
    let titleLabel = UILabel().then {
        $0.text = "로그인"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .nightSky1
    }
    let appleSigninButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black) .then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 14
    }
    let googleSignupButton = MoyangButton(style: .none).then {
        $0.setTitle(" Google 로그인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.setTitleColor(.nightSky1, for: .normal)
        $0.backgroundColor = .sheep1
        $0.setImage(Asset.Images.Signup.google.image, for: .normal)
        $0.layer.borderColor = .nightSky1
        $0.layer.borderWidth = 0.5
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 14
    }
    let loginFailurePopup = MoyangPopupView(style: .oneButton).then {
        $0.title = "로그인 실패"
        $0.desc = "개발자에게 문의하세요"
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
        setupTitleLabel()
        setupAppleLoginButton()
        setupGoogleLoginButton()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(32)
            $0.top.equalTo(navBar.snp.bottom).offset(32)
        }
    }
    private func setupAppleLoginButton() {
        view.addSubview(appleSigninButton)
        appleSigninButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchDown)
        appleSigninButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    private func setupGoogleLoginButton() {
        view.addSubview(googleSignupButton)
        googleSignupButton.addTarget(self, action: #selector(handleGoogleSigninButtonPress), for: .touchDown)
        googleSignupButton.snp.makeConstraints {
            $0.top.equalTo(appleSigninButton.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        vm?.isLoginVC = true
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = vm
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc
    func handleGoogleSigninButtonPress() {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error  == nil else { Log.e(error as Any); return }
            guard let user = user else { return }
            
            user.authentication.do { [weak self] authentication, error in
                guard error == nil else { Log.e(error as Any); return }
                guard authentication != nil else { return }
                
                self?.vm?.googleSignUp(user: user)
            }
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
        
        loginFailurePopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.isLoginSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.loginSuccess()
            }).disposed(by: disposeBag)
        
        output.isLoginFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.loginFailurePopup)
            }).disposed(by: disposeBag)
    }
}

extension LogInVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

protocol LogInVCDelegate: AnyObject {
    func moveToSignUp()
    func loginSuccess()
}
