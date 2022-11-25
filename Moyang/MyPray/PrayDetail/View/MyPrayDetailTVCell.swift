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
    let bubbleLOtherImageView = UIImageView().then { $0.isHidden = true }
    let contentLabel = MoyangLabel().then {
        $0.textColor = .nightSky1
        $0.font = .b02
        $0.numberOfLines = 0
    }
    let nameLabel = MoyangLabel().then {
        $0.textColor = .sheep3
        $0.font = .b05
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
        setupBubbleLOtherImageView()
        setupDateLabel()
        setupNameLabel()
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
    private func setupBubbleLOtherImageView() {
        contentView.addSubview(bubbleLOtherImageView)
        bubbleLOtherImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.right.equalTo(contentLabel).offset(8)
            $0.top.bottom.equalToSuperview().inset(4)
        }
    }
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
    }
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
    }
    
    func updateUI(type: MyPrayDetailVM.ContentItemType) {
        let isMe = type == .startPray || type == .change
        updateContentLabelUI(isMe: isMe)
        updateBubbleImageView(isMe: isMe, isOther: type == .reply)
        updateDateAndNameLabel(isMe: isMe)
    }
    
    func updateUI(type: GroupMemberPrayDetailVM.ContentItemType) {
        let isMe = type == .startPray || type == .change
        updateContentLabelUI(isMe: isMe)
        updateBubbleImageView(isMe: isMe, isOther: type == .reply)
        updateDateAndNameLabel(isMe: isMe)
    }
    
    private func updateContentLabelUI(isMe: Bool) {
        guard let textWidth = contentLabel.text?.longestLine
            .width(withConstraintedHeight: 19, font: .b02) else { return }
        let width = min(textWidth * 1.02, UIScreen.main.bounds.width * 0.65)
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
    private func updateBubbleImageView(isMe: Bool, isOther: Bool) {
        bubbleLImageView.isHidden = isMe && isOther
        bubbleLOtherImageView.isHidden = isMe && !isOther
        
        bubbleRImageView.isHidden = !isMe
        changeImage(isMe: isMe, isOther: isOther)
    }
    private func updateDateAndNameLabel(isMe: Bool) {
        dateLabel.snp.remakeConstraints {
            $0.bottom.equalToSuperview().inset(4)
            if isMe {
                $0.right.equalTo(bubbleRImageView.snp.left).offset(-4)
            } else {
                $0.left.equalTo(bubbleLImageView.snp.right).offset(4)
            }
        }
        nameLabel.isHidden = isMe
        nameLabel.snp.remakeConstraints {
            $0.bottom.equalTo(dateLabel.snp.top).offset(-4)
            if isMe {
                $0.right.equalTo(bubbleRImageView.snp.left).offset(-4)
            } else {
                $0.left.equalTo(bubbleLImageView.snp.right).offset(4)
            }
            
        }
    }
    private func changeImage(isMe: Bool, isOther: Bool) {
        if isMe {
            let inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 28)
            bubbleRImageView.image = Asset.Images.Pray.bubbleR.image.resizableImage(withCapInsets: inset,
                                                                                    resizingMode: .stretch)
            contentLabel.textColor = .nightSky1
        } else {
            if isOther {
                let inset = UIEdgeInsets(top: 20, left: 28, bottom: 20, right: 20)
                bubbleLOtherImageView.image = Asset.Images.Pray.bubbleLOther.image.resizableImage(withCapInsets: inset,
                                                                                                  resizingMode: .stretch)
                contentLabel.textColor = .nightSky1
            } else {
                let inset = UIEdgeInsets(top: 20, left: 28, bottom: 20, right: 20)
                bubbleLImageView.image = Asset.Images.Pray.bubbleL.image.resizableImage(withCapInsets: inset,
                                                                                        resizingMode: .stretch)
                contentLabel.textColor = .sheep1
            }
        }
    }
}

extension String {
    var lineList: [String] {
        return Array(Set(components(separatedBy: .punctuationCharacters).joined(separator: "").components(separatedBy: "\n"))).filter {$0.count > 0}
    }
    var longestLine: String {
        if let max = self.lineList.max(by: {$1.count > $0.count}) {
            return max
        } else {return ""}
    }
}
