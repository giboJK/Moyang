//
//  GroupInfoTableViewCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/10.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class GroupInfoTableViewCell: UITableViewCell {
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: -
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
    }
    let nextImageView = UIImageView().then {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .medium)
        $0.image = UIImage(systemName: "chevron.right", withConfiguration: config)
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
    
    // MARK: - UI
    private func setupUI() {
        setupNameLabel()
        setupNextImageView()
    }
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(12)
        }
    }
    private func setupNextImageView() {
        contentView.addSubview(nextImageView)
        nextImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(12)
            $0.size.equalTo(16)
        }
    }
}
