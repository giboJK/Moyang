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
        $0.setTitle("그룹 보기", for: .normal)
        $0.setTitleColor(.nightSky3, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    let communityGroupPrayCard = CommunityGroupPrayCard()
    let contentView = UIHostingController(rootView: CommunityMainView())

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit { Log.i(self) }

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
//        addChild(contentView)
//        view.addSubview(contentView.view)
//        setupConstraints()
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
    }
    
    fileprivate func setupConstraints() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.snp.makeConstraints {
            $0.top.equalTo(sermonCard.snp.bottom).offset(20)
            $0.left.right.left.equalToSuperview()
        }
    }
    
    func bind() {
        guard let vm = vm else { Log.e(""); return }
        let output = vm.transform(input: CommunityMainVM.Input())
        
        output.groupName
            .drive(groupNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

protocol CommunityMainVCDelegate: AnyObject {
}
