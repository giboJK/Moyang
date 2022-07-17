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
import AuthenticationServices
import GoogleSignIn

class SignUpVC: UIViewController, VCType {
    typealias VM = SignUpVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: SignUpVCDelegate?
    
    let signInConfig = GIDConfiguration.init(clientID: NetConst.googleClientID)
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
    let titleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .nightSky1
    }
    let appleSigninButton = ASAuthorizationAppleIDButton(type: .signUp, style: .black) .then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 14
    }
    let googleSignupButton = MoyangButton(style: .none).then {
        $0.setTitle("Google로 가입", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.setTitleColor(.nightSky1, for: .normal)
        $0.backgroundColor = .sheep1
        $0.setImage(Asset.Images.Signup.google.image, for: .normal)
        $0.layer.borderColor = .nightSky1
        $0.layer.borderWidth = 0.5
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 14
//        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
//        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -4)
    }
    let logInButton = MoyangButton(style: .none).then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor.nightSky4,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "로그인하기",
            attributes: attributes
        )
        $0.setAttributedTitle(attributeString, for: .normal)
    }
    let emailExistPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .primary, secondButtonStyle: .ghost).then {
        $0.title = "이미 가입된 이메일"
        $0.desc = "다른 계정을 사용하거나 다른 로그인 방식으로 로그인해주세요"
        $0.firstButton.setTitle("로그인하기", for: .normal)
        $0.secondButton.setTitle("확인", for: .normal)
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
        setupLogInButton()
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
    private func setupLogInButton() {
        view.addSubview(logInButton)
        logInButton.snp.makeConstraints {
            $0.top.equalTo(googleSignupButton.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
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
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.isEmailNotExist
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let signupVM = self?.vm else { return }
                self?.coordinator?.startProfileProcess(vm: signupVM)
            }).disposed(by: disposeBag)
        
        output.isAlreadyExist
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.emailExistPopup)
            }).disposed(by: disposeBag)
    }
}

extension SignUpVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

protocol SignUpVCDelegate: AnyObject {
    func startProfileProcess(vm: SignUpVM)
    func moveToLogin()
}
