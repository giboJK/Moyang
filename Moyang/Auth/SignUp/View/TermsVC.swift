//
//  TermsVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/11.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import WebKit

class TermsVC: UIViewController, VCType {
    typealias VM = DummyVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: TermsVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
        $0.title = "이용약관"
    }
    let webView = WKWebView().then {
        $0.backgroundColor = .sheep4
    }
    let agreeButton = MoyangButton(.primary).then {
        $0.setTitle("동의", for: .normal)
    }
    let disagreeButton = MoyangButton(.ghost).then {
        $0.setTitle("거절", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        requestURL()
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        view.backgroundColor = .sheep2
        setupNavBar()
        setupAgreeButton()
        setupDisagreeButton()
        setupWebView()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(agreeButton.snp.top).offset(-8)
        }
    }
    private func setupAgreeButton() {
        view.addSubview(agreeButton)
        agreeButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(32)
            $0.right.equalToSuperview().inset(28)
            $0.width.equalToSuperview().dividedBy(2).inset(20)
        }
    }
    private func setupDisagreeButton() {
        view.addSubview(disagreeButton)
        disagreeButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(32)
            $0.left.equalToSuperview().inset(28)
            $0.width.equalToSuperview().dividedBy(2).inset(20)
        }
    }

    private func requestURL() {
        if let url = URL(string: "https://tistory3.daumcdn.net/tistory/3831166/skin/images/moyang%20privacy%20policy.html") {
            let request = URLRequest(url: url)
            webView.load(request)
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
        
        agreeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapAgreeButton()
            }).disposed(by: disposeBag)
        
        disagreeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapDisAgreeButton()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
    }
}

protocol TermsVCDelegate: AnyObject {
    func didTapAgreeButton()
    func didTapDisAgreeButton()
}
