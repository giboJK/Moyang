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
    let orderButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("최근순", attributes: container)
        configuration.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        $0.configuration = configuration
    }
    let memberButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("모두", attributes: container)
        configuration.image = UIImage(systemName: "person.crop.circle.badge.checkmark")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        $0.configuration = configuration
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .sheep1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupOrderButton()
        setupMemberButton()
    }
    private func setupOrderButton() {
        addSubview(orderButton)
        orderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(28)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupMemberButton() {
        addSubview(memberButton)
        memberButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(28)
            $0.left.equalTo(orderButton.snp.right).offset(12)
        }
    }
}
