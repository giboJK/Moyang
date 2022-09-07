//
//  PrayTagCVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import UIKit

class PrayTagCVCell: UICollectionViewCell {
    let tagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .sheep2
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .wilderness2
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupTagLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTagLabel() {
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

class PrayingTagCollectionViewCell: UICollectionViewCell {
    let tagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .sheep2
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .nightSky4
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupTagLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTagLabel() {
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
