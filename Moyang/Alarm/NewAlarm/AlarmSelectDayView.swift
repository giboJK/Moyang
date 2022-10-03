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
        $0.setImage(UIImage(systemName: "checkmark"), for: .normal)
        $0.tintColor = .sheep1
    }
    let divider = UIView().then {
        $0.backgroundColor = .sheep4
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
        backgroundColor = .nightSky2.withAlphaComponent(0.3)
        setupDayLabel()
        setupChcekmarkImageView()
        setupDivider()
    }
    
    private func setupDayLabel() {
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupChcekmarkImageView() {
        addSubview(chcekmarkImageView)
        chcekmarkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
            $0.size.equalTo(28)
        }
    }
    private func setupDivider() {
        addSubview(divider)
        divider.snp.makeConstraints {
            $0.left.equalTo(dayLabel)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
