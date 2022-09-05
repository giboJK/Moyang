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
    let firstLabel = UILabel().then {
        $0.textColor = .sheep2
        $0.font = .systemFont(ofSize: 33, weight: .semibold)
        $0.textAlignment = .left
    }
    let secondLabel = UILabel().then {
        $0.textColor = .sheep2
        $0.font = .systemFont(ofSize: 19, weight: .regular)
        $0.textAlignment = .left
    }
    let thirdLabel = UILabel().then {
        $0.textColor = .sheep2
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
        $0.textAlignment = .left
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
        bindVM()
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
            .skip(1)
            .drive(onNext: { [weak self] _ in
                
            }).disposed(by: disposeBag)
    }
}

protocol SplashVCDelegate: AnyObject {
    func loginSuccess()
    func loginFailure()
}
