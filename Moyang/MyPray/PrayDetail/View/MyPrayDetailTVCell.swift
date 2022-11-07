//
//  MyPrayDetailTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//


import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class MyPrayDetailTVCell: UITableViewCell {
    let bubbleRImageView = UIImageView(image: Asset.Images.Pray.bubbleR.image)
    let bubbleLImageView = UIImageView(image: Asset.Images.Pray.bubbleL.image)
    let contentLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .b02
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
        backgroundColor = .nightSky1
        setupContentLabel()
    }
    
    private func setupContentLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
}
