//
//  BookSelectCVCell.swift
//  Moyang
//
//  Created by kibo on 2022/08/24.
//

import UIKit

class BookSelectCVCell: UICollectionViewCell {
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .nightSky1
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .sheep2
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupContentLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
