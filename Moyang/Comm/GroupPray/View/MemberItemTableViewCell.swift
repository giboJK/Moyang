//
//  MemberItemTableViewCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/02.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class MemberItemTableViewCell: UITableViewCell {
    var disposeBag: DisposeBag = DisposeBag()
    // MARK: - UI
    let nameLabel = UILabel().then {
        $0.textColor = .nightSky1
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    let checkedView = UIImageView(image: UIImage(systemName: "checkmark")).then {
        $0.isHidden = true
        $0.tintColor = .ydGreen1
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
        contentView.backgroundColor = .sheep1
        setupNameLabel()
        setupCheckedView()
    }
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    private func setupCheckedView() {
        contentView.addSubview(checkedView)
        checkedView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
