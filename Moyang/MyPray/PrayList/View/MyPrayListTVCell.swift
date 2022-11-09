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
    let forwardImageView = UIImageView(image: UIImage(systemName: "chevron.forward")).then {
        $0.tintColor = .sheep3
    }
    let dateLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .b02
    }
    let titleLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .b01
    }
    let contentLabel = MoyangLabel().then {
        $0.numberOfLines = 3
        $0.lineBreakStrategy = .hangulWordPriority
    }
    let latestPrayDateLabel = MoyangLabel()
    let prayButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("기도하기", for: .normal)
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
        setupDateLabel()
        setupForwardImageView()
        setuptitleLabel()
        setupcontentLabel()
        setuplatestPrayDateLabel()
        setupPrayButton()
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .nightSky3
    }
    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setupForwardImageView() {
        addSubview(forwardImageView)
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(10)
            $0.height.equalTo(16)
        }
    }
    private func setuptitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupcontentLabel() {
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(88)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setuplatestPrayDateLabel() {
        addSubview(latestPrayDateLabel)
        latestPrayDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(170)
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    private func setupPrayButton() {
        addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(148)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(36)
            $0.width.equalTo(92)
        }
    }
}
