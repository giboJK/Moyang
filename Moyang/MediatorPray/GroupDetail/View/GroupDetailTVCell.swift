//
//  GroupDetailTVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/21.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class GroupDetailTVCell: UITableViewCell {
    let container = UIView().then {
        $0.backgroundColor = .nightSky3
        $0.layer.cornerRadius = 12
    }
    let nameLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .b01
    }
    let forwardImageView = UIImageView(image: UIImage(systemName: "chevron.forward")).then {
        $0.tintColor = .sheep3
    }
    let categoryLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .b03
    }
    let latestDateLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .c02
    }
    let hasNewView = UIView().then {
        $0.backgroundColor = .appleRed1
        $0.layer.cornerRadius = 3
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        setupContentView()
        setupContainer()
    }
    private func setupContentView() {
        contentView.backgroundColor = .nightSky1
    }
    private func setupContainer() {
        contentView.addSubview(container)
        container.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        setupNameLabel()
        setupForwardImageView()
        setupCategoryLabel()
        setupLatestDateLabel()
        setupHasNewView()
    }
    private func setupNameLabel() {
        container.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(19)
            $0.right.equalToSuperview().inset(44)
        }
    }
    private func setupForwardImageView() {
        container.addSubview(forwardImageView)
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(10)
            $0.height.equalTo(16)
        }
    }
    private func setupCategoryLabel() {
        container.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.left.right.equalToSuperview().inset(16)
            
        }
    }
    private func setupLatestDateLabel() {
        container.addSubview(latestDateLabel)
        latestDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(84)
            $0.bottom.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(14)
        }
    }
    private func setupHasNewView() {
        container.addSubview(hasNewView)
        hasNewView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.size.equalTo(6)
            $0.left.equalToSuperview().inset(12)
        }
    }
}
