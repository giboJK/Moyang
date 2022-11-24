//
//  GroupJoinReqCheckView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/24.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class GroupJoinReqCheckView: UIView {
    typealias VM = GroupDetailVM
    var disposeBag: DisposeBag?
    var vm: VM?
    
    // MARK: - UI
    let hasReqLabel = MoyangLabel().then {
        $0.text = "새로운 가입 요청이 있어요."
        $0.textColor = .sheep1
        $0.font = .c01
    }
    let checkView = UIView().then {
        $0.backgroundColor = .appleRed1
        $0.layer.cornerRadius = 3
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupCheckView()
        setupHasReqLabel()
    }
    private func setupCheckView() {
        addSubview(checkView)
        checkView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalToSuperview().inset(24)
            $0.size.equalTo(6)
        }
    }
    private func setupHasReqLabel() {
        addSubview(hasReqLabel)
        hasReqLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(14)
            $0.left.equalTo(checkView.snp.right)
        }
    }
}
