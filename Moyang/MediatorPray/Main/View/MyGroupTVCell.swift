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
    let nameLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .b01
    }
    let greetingLabel = UILabel().then {
        $0.textColor = .sheep3
        $0.font = .c01
    }
    let prayLabel = UILabel().then {
        $0.textColor = .sheep2
        $0.font = .c01
    }
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.register(PrayTagCVCell.self, forCellWithReuseIdentifier: "cell")
    }
    let bottomLine = UIView().then {
        $0.backgroundColor = .sheep2
    }
    
    var tags = [String]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .nightSky3
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
        contentView.backgroundColor = .sheep1
        setupNameLabel()
        setupDateLabel()
        setupPrayLabel()
    }
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupDateLabel() {
        contentView.addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupPrayLabel() {
        contentView.addSubview(prayLabel)
        prayLabel.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(36)
        }
    }
}

