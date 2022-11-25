//
//  MyGroupTVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/15.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class MyGroupTVCell: UITableViewCell {
    // MARK: - UI
    let container = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .nightSky3
    }
    let nameLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .b01
    }
    let greetingLabel = UILabel().then {
        $0.textColor = .sheep3
        $0.font = .c01
    }
    let prayLabel = UILabel().then {
        $0.text = "중보기도를 요청해보세요 :)"
        $0.textColor = .sheep2
        $0.font = .c01
    }
    let newImageView = UIView().then {
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .appleRed1
        $0.isHidden = true
    }
    
    var tags = [String]()
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
    
    // MARK: - UI
    private func setupUI() {
        contentView.backgroundColor = .nightSky1
        setupContainer()
    }
    private func setupContainer() {
        contentView.addSubview(container)
        container.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(106)
        }
        setupNameLabel()
        setupDateLabel()
        setupPrayLabel()
        setupNewImageView()
    }
    private func setupNameLabel() {
        container.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(19)
        }
    }
    private func setupDateLabel() {
        container.addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(14)
        }
    }
    private func setupPrayLabel() {
        container.addSubview(prayLabel)
        prayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(14)
        }
    }
    private func setupNewImageView() {
        container.addSubview(newImageView)
        newImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.left.equalTo(nameLabel.snp.right)
            $0.size.equalTo(6)
        }
    }
}

