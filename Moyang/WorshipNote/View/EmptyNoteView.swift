//
//  EmptyNoteView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/15.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class EmptyNoteView: UIView {
    
    let emptyImageView = UIImageView().then {
        $0.image = UIImage(systemName: "list.bullet.rectangle.portrait.fill")
        $0.tintColor = .sheep2
    }
    let titleLabel = UILabel().then {
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 21, weight: .semibold)
        $0.textAlignment = .center
        $0.text = "예배 노트를 작성해보세요"
    }
    let descLabel = UILabel().then {
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .center
        $0.lineBreakMode = .byWordWrapping
        $0.text = "하나님께서 내게 주신 말씀을 기록하고 기억해 보세요"
        $0.numberOfLines = 0
    }
    
    
    // MARK: - UI
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupEmptyImageView()
        setupTitleLabel()
        setupDescLabel()
    }
 
    
    private func setupEmptyImageView() {
        addSubview(emptyImageView)
        emptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.5)
            $0.size.equalTo(108)
        }
    }
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImageView.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(60)
        }
    }
    private func setupDescLabel() {
        addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(60)
        }
    }
}
