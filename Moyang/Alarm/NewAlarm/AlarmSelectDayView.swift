//
//  AlarmSelectDayView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/02.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AlarmSelectDayView: UIView {
    // MARK: - UI
    let dayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .sheep1
    }
    let chcekmarkImageView = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark")?.withTintColor(.sheep2), for: .normal)
    }
    
    // MARK: - LifeCycle
    init(day: String) {
        super.init(frame: .zero)
        setupUI()
        dayLabel.text = day
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupDayLabel()
        setupChcekmarkImageView()
    }
    
    private func setupDayLabel() {
        addSubview(setupDayLabel)
        setupDayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupChcekmarkImageView() {
        addSubview(setupDayLabel)
        setupDayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
        }
    }
}
