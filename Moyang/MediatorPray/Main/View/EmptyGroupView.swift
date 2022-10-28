//
//  EmptyGroupView.swift
//  Moyang
//
//  Created by kibo on 2022/10/28.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class EmptyGroupView: UIView {
    
    let emptyImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.3")
        $0.tintColor = .sheep2
    }
    let plusImageView = UIImageView().then {
        $0.image = UIImage(systemName: "plus")
        $0.tintColor = .sheep2
    }
    let descLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .b01
        $0.textAlignment = .center
        $0.lineBreakMode = .byWordWrapping
        $0.text = "공동체에서 더 큰 은혜를 누리세요"
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
        backgroundColor = .nightSky1
        setupEmptyImageView()
        setupPlusImageView()
        setupDescLabel()
    }
    
    private func setupEmptyImageView() {
        addSubview(emptyImageView)
        emptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview().multipliedBy(0.5)
            $0.width.equalTo(132)
            $0.height.equalTo(68)
        }
    }
    private func setupPlusImageView() {
        addSubview(plusImageView)
        plusImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.5)
            $0.left.equalTo(emptyImageView.snp.right).offset(-4)
            $0.size.equalTo(24)
        }
        
    }
    private func setupDescLabel() {
        addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImageView.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(60)
        }
    }
}

