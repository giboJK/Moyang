//
//  CommunityGroupPrayCollectionViewCell.swift
//
//
//  Created by 정김기보 on 2022/05/31.
//

import UIKit

class CommunityGroupPrayCollectionViewCell: UICollectionViewCell {
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .nightSky2
    }
    let prayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
        $0.numberOfLines = 0
    }
    let newView = UIView().then {
        $0.backgroundColor = .appleRed1
        $0.layer.cornerRadius = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .sheep2
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupNameLabel()
        setupDateLabel()
        setupPrayLabel()
        setupNewView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(16)
        }
    }
    
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupPrayLabel() {
        contentView.addSubview(prayLabel)
        prayLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(4)
        }
    }
    private func setupNewView() {
        contentView.addSubview(newView)
        newView.snp.makeConstraints {
            $0.size.equalTo(4)
            $0.top.equalTo(nameLabel).offset(2)
            $0.right.equalTo(nameLabel.snp.left).offset(-2)
        }
    }
}
