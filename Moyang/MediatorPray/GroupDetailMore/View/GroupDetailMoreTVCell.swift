//
//  GroupDetailMoreTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/11/23.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class GroupDetailMoreTVCell: UITableViewCell {
    // MARK: - UI
    let container = UIView().then {
        $0.backgroundColor = .nightSky3
        $0.layer.cornerRadius = 12
    }
    let nameLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .b01
    }
    let leaderLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .b03
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
        contentView.backgroundColor = .clear
    }
    private func setupContainer() {
        contentView.addSubview(container)
        container.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
        setupNameLabel()
        setupLeaderLabel()
    }
    private func setupNameLabel() {
        container.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(19)
        }
    }
    private func setupLeaderLabel() {
        contentView.addSubview(leaderLabel)
        container.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
    }
}
