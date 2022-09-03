//
//  BookSelectTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/08/24.
//

import UIKit

class BookSelectTVCell: UITableViewCell {
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .sheep2
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .nightSky3
        selectedBackgroundView = backgroundView
        
        setupContentLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupContentLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
}
