//
//  ReactionPopupView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/18.
//

import UIKit

class ReactionPopupView: UIView {
    weak var delegate: ReactionPopupViewDelegate?
    
    let buttonContainer = UIView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
    }
    let loveButton = UIButton().then {
        $0.setTitle("❤️", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 4
        $0.tag = PrayReactionType.love.rawValue
    }
    let joyfulButton = UIButton().then {
        $0.setTitle("😄", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 4
        $0.tag = PrayReactionType.joyful.rawValue
    }
    let sadButton = UIButton().then {
        $0.setTitle("😭", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 4
        $0.tag = PrayReactionType.sad.rawValue
    }
    let prayButton = UIButton().then {
        $0.setTitle("🙏", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 4
        $0.tag = PrayReactionType.prayWithYou.rawValue
    }
    
    let actionContainer = UIView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    let copyView = UIView()
    let copyLabel = UILabel().then {
        $0.text = "복사"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky2
        $0.isUserInteractionEnabled = false
    }
    let copyImageView = UIImageView(image: Asset.Images.Pray.copy.image.withTintColor(.nightSky2)).then {
        $0.isUserInteractionEnabled = false
    }
    
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
        loveButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    private func setupJoyfulButton() {
        buttonContainer.addSubview(joyfulButton)
        joyfulButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.size.equalTo(20)
            $0.left.equalTo(loveButton.snp.right).offset(16)
        }
        joyfulButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    private func setupSadButton() {
        buttonContainer.addSubview(sadButton)
        sadButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.size.equalTo(20)
            $0.left.equalTo(joyfulButton.snp.right).offset(16)
        }
        sadButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    private func setupPrayButton() {
        buttonContainer.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.size.equalTo(20)
            $0.right.equalToSuperview().inset(16)
        }
        prayButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    private func setupActionContainer() {
        addSubview(actionContainer)
        actionContainer.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(buttonContainer.snp.bottom).offset(8)
        }
        setupCopyView()
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
            $0.left.equalToSuperview().inset(12)
        }
        copyView.addSubview(copyImageView)
        copyImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(12)
            $0.size.equalTo(20)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCopyView))
        copyView.addGestureRecognizer(tapGesture)
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
    
    @objc func didTapButton(_ sender: UIButton) {
        switch sender.tag {
        case PrayReactionType.love.rawValue:
            delegate?.didTapEmoji(type: .love)
        case PrayReactionType.joyful.rawValue:
            delegate?.didTapEmoji(type: .joyful)
        case PrayReactionType.sad.rawValue:
            delegate?.didTapEmoji(type: .sad)
        case PrayReactionType.prayWithYou.rawValue:
            delegate?.didTapEmoji(type: .prayWithYou)
        default:
            return
        }
    }
    
    @objc func didTapCopyView() {
        delegate?.didTapCopy()
    }
}

protocol ReactionPopupViewDelegate: AnyObject {
    func didTapEmoji(type: PrayReactionType)
    func didTapCopy()
}
