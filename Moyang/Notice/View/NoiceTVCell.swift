//
//  NoiceTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/10/05.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class NoiceTVCell: UITableViewCell {
    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .sheep3
        $0.isUserInteractionEnabled = false
    }
    let arrowImage = UIImageView(image: UIImage(systemName: "chevron.forward")?.withTintColor(.sheep2))
    let bottomLine = UIView().then {
        $0.backgroundColor = .sheep2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .sheep1
        selectedBackgroundView = backgroundView
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI
    private func setupUI() {
        contentView.backgroundColor = .nightSky1
        setupTitleLabel()
        setupDateLabel()
        setupArrowImage()
        
        setupBottomLine()
    }
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(52)
        }
    }
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupArrowImage() {
        contentView.addSubview(arrowImage)
        arrowImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
    }
    private func setupBottomLine() {
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview()
        }
    }
}
