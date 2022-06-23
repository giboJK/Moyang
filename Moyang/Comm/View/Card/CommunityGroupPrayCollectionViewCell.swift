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
        $0.tintColor = .nightSky1
    }
    let prayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.tintColor = .nightSky1
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .sheep2
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupNameLabel()
        setupPrayLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(8)
        }
    }
    private func setupPrayLabel() {
        contentView.addSubview(prayLabel)
        prayLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}