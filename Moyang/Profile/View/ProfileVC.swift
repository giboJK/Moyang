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
    }
    let emailLabel = UILabel().then {
        $0.textColor = .sheep2
        $0.font = .b01
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
        $0.setTitle("계정삭제", for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.appleRed1, for: .normal)
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(48)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupNoticeButton() {
        view.addSubview(noticeButton)
        noticeButton.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(32)
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
    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol ProfileVCDelegate: AnyObject {
    func didTapNoticeButton()
    func didTapAlarmButton()
    func didTapLogoutButton()
}
