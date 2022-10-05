//
//  GroupQTHeader.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/12.
//


import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class GroupQTHeader: UIView {
    let dateLabel = UILabel().then {
        $0.text = "오늘"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let titleLabel = UILabel().then {
        $0.text = "시험을 통과하고 받는\n복되고 견고한 약속"
        $0.font = .systemFont(ofSize: 19, weight: .regular)
        $0.textColor = .sheep2
        $0.numberOfLines = 2
    }
    let versesLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .sheep2
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupDateLabel()
        setupTitleLabel()
        setupVersesLabel()
    }
    
    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupVersesLabel() {
        addSubview(versesLabel)
        versesLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}
