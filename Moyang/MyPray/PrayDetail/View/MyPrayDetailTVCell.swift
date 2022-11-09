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
    let bubbleRImageView = UIImageView().then { $0.isHidden = true }
    let bubbleLImageView = UIImageView().then { $0.isHidden = true }
    let contentLabel = MoyangLabel().then {
        $0.textColor = .nightSky1
        $0.font = .b02
        $0.numberOfLines = 0
    }
    let dateLabel = MoyangLabel().then {
        $0.textColor = .sheep4
        $0.font = .b05
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
        setupBubbleRImageView()
        setupBubbleLImageView()
        setupDateLabel()
        contentView.bringSubviewToFront(contentLabel)
    }
    
    private func setupContentLabel() {
        contentView.addSubview(contentLabel)
    }
    private func setupBubbleRImageView() {
        contentView.addSubview(bubbleRImageView)
        bubbleRImageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.left.equalTo(contentLabel).offset(-8)
            $0.top.bottom.equalToSuperview().inset(4)
        }
    }
    private func setupBubbleLImageView() {
        contentView.addSubview(bubbleLImageView)
        bubbleLImageView.snp.remakeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.right.equalTo(contentLabel).offset(8)
            $0.top.bottom.equalToSuperview().inset(4)
        }
    }
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
    }
    
    func updateUI(type: MyPrayDetailVM.ContentItemType) {
        updateContentLabelUI(isMe: type == .startPray)
        updateBubbleImageView(isMe: type == .startPray)
        updateDateLabel(isMe: type == .startPray)
    }
    
    private func updateContentLabelUI(isMe: Bool) {
        guard let textWidth = contentLabel.text?.width(withConstraintedHeight: 19, font: .b02) else { return }
        let width = min(textWidth * 1.02, UIScreen.main.bounds.width * 0.62)
        contentLabel.snp.remakeConstraints {
            if isMe {
                $0.right.equalToSuperview().inset(24 + 4)
            } else {
                $0.left.equalToSuperview().inset(24 + 4)
            }
            $0.width.equalTo(width)
            $0.top.bottom.equalToSuperview().inset(12)
        }
    }
    private func updateBubbleImageView(isMe: Bool) {
        bubbleLImageView.isHidden = isMe
        bubbleRImageView.isHidden = !isMe
        changeImage(isMe: isMe)
    }
    private func updateDateLabel(isMe: Bool) {
        dateLabel.snp.remakeConstraints {
            $0.bottom.equalToSuperview().inset(4)
            if isMe {
                $0.right.equalTo(bubbleRImageView.snp.left).offset(-4)
            } else {
                $0.left.equalTo(bubbleLImageView.snp.right).offset(4)
            }
        }
    }
    private func changeImage(isMe: Bool) {
        if isMe {
            let inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 28)
            bubbleRImageView.image = Asset.Images.Pray.bubbleR.image.resizableImage(withCapInsets: inset,
                                                                                    resizingMode: .stretch)
        } else {
            let inset = UIEdgeInsets(top: 20, left: 28, bottom: 20, right: 20)
            bubbleLImageView.image = Asset.Images.Pray.bubbleL.image.resizableImage(withCapInsets: inset,
                                                                                    resizingMode: .stretch)
        }
    }
}
