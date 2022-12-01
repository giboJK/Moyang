//
//  ProfileVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class ProfileVC: UIViewController, VCType {
    typealias VM = ProfileVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: ProfileVCDelegate?

    // MARK: - UI
    let nameLabel = UILabel().then {
        $0.textColor = .sheep2
        $0.font = .b01
        $0.numberOfLines = 2
    }
    let emailLabel = UILabel().then {
        $0.textColor = .sheep2
        $0.font = .b02
        $0.numberOfLines = 2
    }
    let dividor = UIView().then {
        $0.backgroundColor = .sheep2.withAlphaComponent(0.4)
    }
    let noticeButton = MoyangButton(.none).then {
        $0.setTitle("공지사항", for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.sheep2, for: .normal)
    }
    let alarmButton = MoyangButton(.none).then {
        $0.setTitle("알람설정", for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.sheep2, for: .normal)
    }
    let logoutButton = MoyangButton(.none).then {
        $0.setTitle("로그아웃", for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.sheep2, for: .normal)
    }
    let deleteButton = MoyangButton(.none).then {
        $0.setTitle("계정탈퇴", for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.appleRed1, for: .normal)
    }
    let versionLabel = UILabel().then {
        $0.textColor = .sheep3
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    let deleteConfirmPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .warning, secondButtonStyle: .sheepGhost).then {
        $0.title = "계정 탈퇴"
        $0.desc = "정말로 탈퇴하시겠어요? 탈퇴하시면 모든 정보가 사라집니다."
        $0.firstButton.setTitle("탈퇴", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    let deleteFailurePopup = MoyangPopupView(style: .oneButton, firstButtonStyle: .warning).then {
        $0.title = "계정 탈퇴 실패"
        $0.desc = "개발자에게 문의주세요. teoeirm@gmail.com"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupNameLabel()
        setupEmailLabel()
        setupDividor()
        setupNoticeButton()
//        setupAlarmButton()
        setupLogoutButton()
        setupDeleteButton()
        setupVersionLabel()
    }
    // MARK: - Binding
    func bind() {
        bindVM()
        bindViews()
    }
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(52)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupDividor() {
        view.addSubview(dividor)
        dividor.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    private func setupNoticeButton() {
        view.addSubview(noticeButton)
        noticeButton.snp.makeConstraints {
            $0.top.equalTo(dividor.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
    private func setupAlarmButton() {
        view.addSubview(alarmButton)
        alarmButton.snp.makeConstraints {
            $0.top.equalTo(noticeButton.snp.bottom)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
    private func setupLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(noticeButton.snp.bottom)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
    private func setupDeleteButton() {
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
    
    private func setupVersionLabel() {
        view.addSubview(versionLabel)
        versionLabel.text = "버전 " + CommonUtils.currentVersion + "." + CommonUtils.currentBuildVersion
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    private func bindViews() {
        logoutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapLogoutButton()
            }).disposed(by: disposeBag)
        
        noticeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapNoticeButton()
            }).disposed(by: disposeBag)
        
        alarmButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapAlarmButton()
            }).disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.deleteConfirmPopup)
            }).disposed(by: disposeBag)
        
        deleteConfirmPopup.firstButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        deleteConfirmPopup.secondButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        deleteFailurePopup.firstButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(deleteAccount: deleteConfirmPopup.firstButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.name
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.email
            .drive(emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.deletionSuccess
            .skip(1)
            .drive(onNext: {[weak self] _ in
                self?.coordinator?.didTapLogoutButton()
            }).disposed(by: disposeBag)
        
        output.deletionFailure
            .skip(1)
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.deleteFailurePopup)
            }).disposed(by: disposeBag)
        
    }
}

protocol ProfileVCDelegate: AnyObject {
    func didTapNoticeButton()
    func didTapAlarmButton()
    func didTapLogoutButton()
}
