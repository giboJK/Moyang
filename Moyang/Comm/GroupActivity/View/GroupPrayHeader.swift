//
//  GroupPrayCalendar.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/29.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class GroupPrayHeader: UIView {
    let thisMonthTopicView = ThisMonthTopicView()
    let prayButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("기도하기", attributes: container)
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        $0.configuration = configuration
    }
    let groupNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .sheep2
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
        setupThisMonthTopicView()
        setupPrayButton()
        setupGroupNameLabel()
    }
    
    private func setupThisMonthTopicView() {
        addSubview(thisMonthTopicView)
        thisMonthTopicView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(100)
        }
    }
    private func setupPrayButton() {
        addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(44)
            $0.height.equalTo(36)
            $0.centerX.equalToSuperview()
        }
    }
    private func setupGroupNameLabel() {
        addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(20)
        }
    }
}
