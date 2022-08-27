//
//  MoyangNavBar.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/24.
//

import UIKit
import RxCocoa
import SnapKit
import Then
import RxGesture

class MoyangNavBar: UIView {
    enum NavBarStyle {
        case light
        case dark
    }

    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.backward")?.withTintColor(.sheep2), for: .normal)
    }
    let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark")?.withTintColor(.sheep2), for: .normal)
    }
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .heavy)
        $0.textColor = .sheep2
        $0.textAlignment = .center
    }
    
    var style: NavBarStyle = .light
    
    var isHiddenWithAnimation: Bool = false {
        didSet(v) {
            UIView.animate(withDuration: 0.5) {
                self.alpha = v ? 1 : 0
            }
        }
    }
    
    var title: String? {
        get {
            return titleLabel.text
        } set(v) {
            titleLabel.text = v
        }
    }
    
    required init(_ style: NavBarStyle = .light) {
        super.init(frame: CGRect(x: 0, y: 0,
                                 width: UIScreen.main.bounds.width,
                                 height: UIApplication.statusBarHeight + 44))
        self.style = style
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        if style == .light {
            backgroundColor = .sheep2
        } else {
            backgroundColor = .nightSky1
        }
        setupBackButton()
        setupCloseButton()
        setupTitleLabel()
    }
    
    private func setupBackButton() {
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(24)
        }
        if style == .light {
            backButton.setImage(UIImage(systemName: "chevron.backward")?.withTintColor(.nightSky1),
                                for: .normal)
            backButton.tintColor = .nightSky1
        } else {
            backButton.setImage(UIImage(systemName: "chevron.backward")?.withTintColor(.sheep1),
                                for: .normal)
            backButton.tintColor = .sheep2
        }
    }
    
    private func setupCloseButton() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(24)
        }
        if style == .light {
            closeButton.setImage(UIImage(systemName: "xmark")?.withTintColor(.nightSky1),
                                for: .normal)
            closeButton.tintColor = .nightSky1
        } else {
            closeButton.setImage(UIImage(systemName: "xmark")?.withTintColor(.sheep1),
                                for: .normal)
            closeButton.tintColor = .sheep2
        }
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(48)
        }
        if style == .light {
            titleLabel.textColor = .nightSky1
        } else {
            titleLabel.textColor = .sheep2
        }
    }
}
