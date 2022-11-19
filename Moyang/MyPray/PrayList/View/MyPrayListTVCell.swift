//
//  MyPrayListTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/11/09.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class MyPrayListTVCell: UITableViewCell {
    let container = UIView().then {
        $0.backgroundColor = .nightSky3
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    let forwardImageView = UIImageView(image: UIImage(systemName: "chevron.forward")).then {
        $0.tintColor = .sheep3
    }
    let titleLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .b01
    }
    let contentLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .b04
        $0.numberOfLines = 3
        $0.lineBreakStrategy = .hangulWordPriority
    }
    let latestPrayDateLabel = MoyangLabel().then {
        $0.textColor = .sheep3
        $0.font = .c01
    }
    let dateLabel = MoyangLabel().then {
        $0.textColor = .sheep3
        $0.font = .c01
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
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(24)
        }
        setupTitleLabel()
        setupForwardImageView()
        setupcontentLabel()
        setupLatestPrayDateLabel()
        setupDateLabel()
    }
    private func setupTitleLabel() {
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(32)
        }
    }
    private func setupForwardImageView() {
        container.addSubview(forwardImageView)
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(10)
            $0.height.equalTo(16)
        }
    }
    private func setupcontentLabel() {
        container.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupLatestPrayDateLabel() {
        container.addSubview(latestPrayDateLabel)
        latestPrayDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(132)
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(14)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    private func setupDateLabel() {
        container.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(latestPrayDateLabel)
            $0.right.equalToSuperview().inset(16)
        }
    }
}
