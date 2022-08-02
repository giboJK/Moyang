//
//  ReactionPopupView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/18.
//

import UIKit

class ReactionPopupView: UIView {
    
    let buttonContainer = UIView().then {
        $0.backgroundColor = .nightSky4
        $0.layer.cornerRadius = 8
    }
    let loveButton = UIButton().then {
        $0.setTitle("❤️", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 4
    }
    let joyfulButton = UIButton().then {
        $0.setTitle("😄", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 4
    }
    let sadButton = UIButton().then {
        $0.setTitle("😭", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 4
    }
    let prayButton = UIButton().then {
        $0.setTitle("🙏", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 4
    }
    
    let actionContainer = UIView().then {
        $0.backgroundColor = .nightSky4
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    let copyView = UIView()
    let copyLabel = UILabel().then {
        $0.text = "복사"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep1
    }
    let copyImageView = UIImageView(image: Asset.Images.Pray.copy.image.withTintColor(.sheep1))
    let replyView = UIView()
    let replyLabel = UILabel().then {
        $0.text = "같이 기도하기"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep1
    }
    let replyImageView = UIImageView(image: Asset.Images.Pray.comment.image.withTintColor(.sheep1))
    let changeView = UIView()
    let changeLabel = UILabel().then {
        $0.text = "변화 기록하기"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep1
    }
    let changeImageView = UIImageView(image: Asset.Images.Pray.changeRecord.image.withTintColor(.sheep1))
    
    required init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    deinit { Log.i(self) }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        setupButtons()
        setupActionContainer()
    }
    
    private func setupButtons() {
        addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
        }
        setupLoveButton()
        setupJoyfulButton()
        setupSadButton()
        setupPrayButton()
    }
    private func setupLoveButton() {
        buttonContainer.addSubview(loveButton)
        loveButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.size.equalTo(20)
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    private func setupJoyfulButton() {
        buttonContainer.addSubview(joyfulButton)
        joyfulButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.size.equalTo(20)
            $0.left.equalTo(loveButton.snp.right).offset(16)
        }
    }
    private func setupSadButton() {
        buttonContainer.addSubview(sadButton)
        sadButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.size.equalTo(20)
            $0.left.equalTo(joyfulButton.snp.right).offset(16)
        }
    }
    private func setupPrayButton() {
        buttonContainer.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.size.equalTo(20)
            $0.right.equalToSuperview().inset(16)
        }
    }
    private func setupActionContainer() {
        addSubview(actionContainer)
        actionContainer.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(buttonContainer.snp.bottom).offset(8)
        }
        setupCopyView()
    }
    func updateActionContainer(isMyPrayList: Bool) {
        if isMyPrayList {
            setupChangeView()
        } else {
            setupReplyView()
        }
    }
    private func setupCopyView() {
        actionContainer.addSubview(copyView)
        copyView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        let bottomBorder = UIView().then {
            $0.backgroundColor = .sheep2
        }
        copyView.addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        copyView.addSubview(copyLabel)
        copyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(8)
        }
        copyView.addSubview(copyImageView)
        copyImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
            $0.size.equalTo(20)
        }
    }
    private func setupReplyView() {
        actionContainer.addSubview(replyView)
        replyView.snp.makeConstraints {
            $0.top.equalTo(copyView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview()
        }
        replyView.addSubview(replyLabel)
        replyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(8)
        }
        replyView.addSubview(replyImageView)
        replyImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
            $0.size.equalTo(20)
        }
    }
    private func setupChangeView() {
        actionContainer.addSubview(changeView)
        changeView.snp.makeConstraints {
            $0.top.equalTo(copyView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview()
        }
        changeView.addSubview(changeLabel)
        changeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(8)
        }
        changeView.addSubview(changeImageView)
        changeImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
            $0.size.equalTo(20)
        }
    }

    func setMyReaction(reaction: Int) {
        if let reactionType = PrayReactionType(rawValue: reaction) {
            let buttons = [loveButton, joyfulButton, sadButton, prayButton]
            buttons.forEach { $0.backgroundColor = .clear}
            switch reactionType {
            case .love:
                loveButton.backgroundColor = .sheep2
            case .sad:
                sadButton.backgroundColor = .sheep2
            case .joyful:
                joyfulButton.backgroundColor = .sheep2
            case .prayWithYou:
                prayButton.backgroundColor = .sheep2
            }
        }
    }
}
