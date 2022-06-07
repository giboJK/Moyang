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
    var vm: CommunityMainVM?
    var coordinator: CommunityMainVCDelegate?
    
    // MARK: - UI
    let sermonCard = SermonCard()
    lazy var scrollView = CommunityMainScrollView(disposeBag: disposeBag).then {
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.layer.masksToBounds = true
        $0.backgroundColor = .sheep2
    }
    let groupNameLabel = UILabel().then {
        $0.textColor = .nightSky1
        $0.font = .systemFont(ofSize: 17, weight: .bold)
    }
    let moreGroupButton = UIButton().then {
        $0.setTitle("그룹", for: .normal)
        $0.setTitleColor(.nightSky3, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    let communityGroupPrayCard = CommunityGroupPrayCard()
    let confirmPopupView = MoyangPopupView(style: .oneButton).then {
        $0.title = "나는 거룩한 하나님의 자녀입니다."
        $0.firstButton.setTitle("네!", for: .normal)
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupUI() {
        title = "공동체"
        view.backgroundColor = .nightSky3
        setupSermonCard()
        setupScrollView()
        displayPopup(popup: confirmPopupView)
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
        setupMoreGroupButton()
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
    private func setupMoreGroupButton() {
        scrollView.container.addSubview(moreGroupButton)
        moreGroupButton.snp.makeConstraints {
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
    
    func bind() {
        bindViews()
        bindVM()
    }
    
    func bindViews() {
        confirmPopupView.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
    }
    
    func bindVM() {
        guard let vm = vm else { Log.e(""); return }
        let didTapPrayCard = communityGroupPrayCard.rx.tapGesture().when(.ended)
            .map { _ in () }.asDriver(onErrorJustReturn: ())
        let input = CommunityMainVM.Input(didTapPrayCard: didTapPrayCard)
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(groupNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.groupPrayVM
            .drive(onNext: { [weak self] groupPrayVM in
                guard let groupPrayVM = groupPrayVM else { return }
                self?.coordinator?.didTapGroupPrayCard(groupPrayVM: groupPrayVM)
            }).disposed(by: disposeBag)
    }
}

protocol CommunityMainVCDelegate: AnyObject {
    func didTapGroupPrayCard(groupPrayVM: GroupPrayVM)
}
