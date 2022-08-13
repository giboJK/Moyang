//
//  CommunityMainVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/14.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SwiftUI
import SnapKit
import RxGesture

class CommunityMainVC: UIViewController, VCType {
    typealias VM = CommunityMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: CommunityMainVCDelegate?
    
    // MARK: - UI
    let sermonCard = SermonCard()
    lazy var scrollView = CommunityMainScrollView(disposeBag: disposeBag).then {
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.layer.masksToBounds = true
        $0.backgroundColor = .nightSky1
    }
    let groupNameLabel = UILabel().then {
        $0.textColor = .nightSky1
        $0.font = .systemFont(ofSize: 17, weight: .bold)
    }
    let allGroupButton = MoyangButton(.none).then {
        $0.setTitle("모든 그룹", for: .normal)
        $0.setTitleColor(.sheep2, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    let communityGroupPrayCard = CommunityGroupPrayCard()
    let emptyGroupView = EmptyGroupView()
    let networkIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
//        presentQuickPrayVC()
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupUI() {
        title = "공동체"
        view.backgroundColor = .nightSky1
        setupSermonCard()
        setupScrollView()
        setupEmptyGroupView()
        setupNetworkIndicator()
    }
    
    private func setupSermonCard() {
        view.addSubview(sermonCard)
        sermonCard.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(240)
        }
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(sermonCard.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        setupGroupNameLabel()
        setupAllGroupButton()
        setupCommunityGroupPrayCard()
    }
    private func setupGroupNameLabel() {
        scrollView.container.addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(160)
        }
    }
    private func setupAllGroupButton() {
        scrollView.container.addSubview(allGroupButton)
        allGroupButton.snp.makeConstraints {
            $0.top.bottom.equalTo(groupNameLabel)
            $0.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupCommunityGroupPrayCard() {
        scrollView.container.addSubview(communityGroupPrayCard)
        communityGroupPrayCard.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.left.right.equalToSuperview().inset(16)
        }
        communityGroupPrayCard.vm = self.vm
        communityGroupPrayCard.bind()
        communityGroupPrayCard.dropShadow()
    }
    
    private func setupEmptyGroupView() {
        view.addSubview(emptyGroupView)
        emptyGroupView.snp.makeConstraints {
            $0.top.equalTo(sermonCard.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    private func setupNetworkIndicator() {
        view.addSubview(networkIndicator)
        networkIndicator.center = view.center
    }
    
    private func presentQuickPrayVC() {
        if let isToday = UserData.shared.todayPrayPopup {
            if Date().toString("yyyy-MM-dd") == isToday {
                return
            }
        }
        UserData.shared.todayPrayPopup = Date().toString("yyyy-MM-dd")
        let vc = QuickPrayVC()
        vc.vm = self.vm
        vc.bind()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func bind() {
        bindViews()
        bindVM()
    }
    
    func bindViews() {
        allGroupButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.showAllGroup()
            }).disposed(by: disposeBag)
        
        communityGroupPrayCard.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapGroupPrayCard()
            }).disposed(by: disposeBag)
    }
    
    func bindVM() {
        guard let vm = vm else { Log.e(""); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(groupNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isEmptyGroup
            .map { $0 }
            .drive(scrollView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isEmptyGroup
            .map { !$0 }
            .drive(emptyGroupView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isNetworking
            .drive(onNext: { [weak self] isNetworking in
                guard let self = self else { return }
                if isNetworking {
                    self.networkIndicator.startAnimating()
                } else {
                    self.networkIndicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
}

protocol CommunityMainVCDelegate: AnyObject {
    func didTapGroupPrayCard()
    func showAllGroup()
    func letsPray()
}
