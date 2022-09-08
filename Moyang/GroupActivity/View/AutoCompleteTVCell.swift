//
//  AutoCompleteTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/08/24.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class AutoCompleteTVCell: UITableViewCell {
    // MARK: - UI
    let tagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
    }
    let bottomLine = UIView().then {
        $0.backgroundColor = .sheep4
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
        setupTagLabel()
        setupBottomLine()
    }
    private func setupTagLabel() {
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
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
