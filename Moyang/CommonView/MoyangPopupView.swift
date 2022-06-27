//
//  MoyangPopupView.swift
//
//
//  Created by 정김기보 on 2022/06/04.
//

import UIKit
import SnapKit
import Then

class MoyangPopupView: UIView {
    
    // MARK: - Enumeration
    enum PopupStyle {
        case oneButton
        case twoButton
        case custom
    }
    let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .nightSky1
        $0.numberOfLines = 0
    }
    let descLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
        $0.numberOfLines = 0
    }
    let firstButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.tintColor = .sheep1
        $0.backgroundColor = .nightSky1
        $0.layer.cornerRadius = 12
    }
    let secondButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.tintColor = .sheep1
        $0.backgroundColor = .sheep4
        $0.layer.cornerRadius = 12
    }
    var popupWidth: CGFloat = UIScreen.main.bounds.width - 48
    
    var title: String? {
        get {
            return titleLabel.text
        } set(v) {
            titleLabel.text = v
        }
    }
    
    var desc: String? {
        get {
            return descLabel.text
        } set(v) {
            descLabel.text = v
        }
    }
    
    var style: PopupStyle = .oneButton
    
    var topMargin: CGFloat = 20
    var leftMargin: CGFloat = 20
    var bottomMargin: CGFloat = 20
    var rightMargin: CGFloat = 20
    
    required init(style: PopupStyle) {
        self.style = style
        super.init(frame: .zero)
        setupUI()
    }
    
    deinit { Log.i(self) }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        containerView.backgroundColor = .sheep1
        containerView.layer.cornerRadius = 17.0
        switch style {
        case .oneButton:
            setupOneButtonPopup()
        case .twoButton:
            setupTwoButtonPopup()
        case .custom:
            break
        }
        
        UIView.animate(withDuration: 0) {
            self.layoutIfNeeded()
        }
    }
    
    private func setupOneButtonPopup() {
        setupContainerView()
        setupTitleLabel()
        setupDescLabel()
        setupFirstButton()
    }
    private func setupTwoButtonPopup() {
        topMargin = 28
        setupContainerView()
        setupTitleLabel()
        setupDescLabel()
        setupFirstButton()
        setupSecondButton()
    }
    
    private func setupContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(popupWidth)
        }
    }
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(topMargin)
            $0.left.equalToSuperview().inset(leftMargin)
            $0.right.equalToSuperview().inset(rightMargin)
        }
    }
    private func setupDescLabel() {
        containerView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(leftMargin)
            $0.right.equalToSuperview().inset(rightMargin)
        }
    }
    private func setupFirstButton() {
        containerView.addSubview(firstButton)
        firstButton.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(leftMargin)
            $0.right.equalToSuperview().inset(rightMargin)
            $0.height.equalTo(50)
            if style == .oneButton {
                $0.bottom.equalToSuperview().inset(bottomMargin)
            }
        }
    }
    private func setupSecondButton() {
        containerView.addSubview(secondButton)
        secondButton.snp.makeConstraints {
            $0.top.equalTo(firstButton.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(leftMargin)
            $0.right.equalToSuperview().inset(rightMargin)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(bottomMargin)
        }
    }
}
