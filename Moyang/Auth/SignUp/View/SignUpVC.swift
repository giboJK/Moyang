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
    let appleSigninButton = ASAuthorizationAppleIDButton(type: .signUp, style: .white) .then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    let googleSignupButton = MoyangButton(style: .none).then {
        $0.setTitle(" Google 가입", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.setTitleColor(.nightSky1, for: .normal)
        $0.backgroundColor = .sheep1
        $0.setImage(Asset.Images.Signup.google.image, for: .normal)
    }
    let logInButton = MoyangButton(style: .none).then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.b02,
            .foregroundColor: UIColor.sheep3,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "로그인하기",
            attributes: attributes
        )
        $0.setAttributedTitle(attributeString, for: .normal)
    }
    let emailExistPopup = MoyangPopupView(style: .twoButton,
                                          firstButtonStyle: .nightPrimary,
                                          secondButtonStyle: .nightGhost).then {
        $0.title = "이미 가입된 이메일"
        $0.desc = "다른 계정을 사용하거나 다른 로그인 방식으로 로그인해주세요"
        $0.firstButton.setTitle("로그인하기", for: .normal)
        $0.secondButton.setTitle("확인", for: .normal)
    }
    let registerFailurePopup = MoyangPopupView(style: .oneButton,
                                             firstButtonStyle: .warning).then {
        $0.title = "회원 가입 실패"
        $0.desc = "개발자에게 문의해주세요"
        $0.firstButton.setTitle("확인", for: .normal)
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
        view.backgroundColor = .nightSky1
        title = "회원가입"
        setupAppleLoginButton()
        setupGoogleLoginButton()
        setupLogInButton()
    }
    private func setupAppleLoginButton() {
        view.addSubview(appleSigninButton)
        appleSigninButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchDown)
        appleSigninButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    private func setupGoogleLoginButton() {
        view.addSubview(googleSignupButton)
        googleSignupButton.addTarget(self, action: #selector(handleGoogleSigninButtonPress), for: .touchDown)
        googleSignupButton.snp.makeConstraints {
            $0.top.equalTo(appleSigninButton.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
    private func setupLogInButton() {
        view.addSubview(logInButton)
        logInButton.snp.makeConstraints {
            $0.top.equalTo(googleSignupButton.snp.bottom).offset(24)
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
        
        registerFailurePopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        logInButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.moveToLogin()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.isRegisterSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.moveToMainVC()
            }).disposed(by: disposeBag)
        
        output.isRegisterFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.registerFailurePopup)
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
    func moveToLogin()
    func moveToMainVC()
}
