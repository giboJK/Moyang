//
//  SplashVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/27.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class SplashVC: UIViewController, VCType {
    typealias VM = SplashVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: SplashVCDelegate?

    // MARK: - UI
    let firstLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .t01
        $0.textAlignment = .left
    }
    let secondLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .headline
        $0.textAlignment = .left
    }
    let thirdLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .t04
        $0.textAlignment = .left
    }
    let requiredPopup = MoyangPopupView(style: .oneButton, firstButtonStyle: .secondary).then {
        $0.desc = "최신 버전의 앱을 설치하셔야 서비스를 이용하실 수 있습니다."
        $0.firstButton.setTitle("업데이트 하기", for: .normal)
    }
    let recommendedPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .secondary, secondButtonStyle: .ghost).then {
        $0.desc = "최신 버전의 앱으로 업데이트를 권장합니다. 최신 버전으로 앱을 업데이트 해주세요."
        $0.firstButton.setTitle("업데이트 하기", for: .normal)
        $0.secondButton.setTitle("확인", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
            self.startAnimation()
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backButtonDisplayMode = .minimal
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupFirstLabel()
        setupSecondLabel()
        setupThirdLabel()
    }
    private func setupFirstLabel() {
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.centerY.equalToSuperview().offset(-40)
        }
    }
    private func setupSecondLabel() {
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.centerY.equalToSuperview().offset(6)
            
        }
    }
    private func setupThirdLabel() {
        view.addSubview(thirdLabel)
        thirdLabel.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.centerY.equalToSuperview().offset(32)
        }
    }
    
    private func startAnimation() {
        secondLabel.snp.updateConstraints {
            $0.centerY.equalToSuperview()
        }
        thirdLabel.snp.updateConstraints {
            $0.centerY.equalToSuperview().offset(24)
        }
        UIView.animate(withDuration: 0.7) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        requiredPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        recommendedPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        recommendedPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
                self?.vm?.autoLogin()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        output.first
            .drive(firstLabel.rx.text)
            .disposed(by: disposeBag)
        output.second
            .drive(secondLabel.rx.text)
            .disposed(by: disposeBag)
        output.third
            .drive(thirdLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isLoginSuccess
            .skip(1)
            .delay(.milliseconds(700))
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.loginSuccess()
            }).disposed(by: disposeBag)
        
        output.isLoginFailure
            .skip(1)
            .delay(.milliseconds(700))
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.loginFailure()
            }).disposed(by: disposeBag)
        
        output.isRequired
            .delay(.milliseconds(700))
            .drive(onNext: { [weak self] isRequired in
                guard let self = self else { return }
                if isRequired {
                    self.displayPopup(popup: self.requiredPopup)
                }
            }).disposed(by: disposeBag)
        
        output.isRecommended
            .delay(.milliseconds(700))
            .drive(onNext: { [weak self] isRecommended in
                guard let self = self else { return }
                if isRecommended {
                    self.displayPopup(popup: self.recommendedPopup)
                }
            }).disposed(by: disposeBag)
    }
}

protocol SplashVCDelegate: AnyObject {
    func loginSuccess()
    func loginFailure()
}
