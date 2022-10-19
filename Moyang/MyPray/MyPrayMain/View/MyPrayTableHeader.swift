//
//  MyPrayTableHeader.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/19.
//


import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class MyPrayTableHeader: UIView {
    let newMemoButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
    }
    let searchButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
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
        setupNewMemoButton()
        setupSearchButton()
    }
    private func setupNewMemoButton() {
        addSubview(newMemoButton)
        newMemoButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(24)
            $0.right.equalToSuperview().inset(20)
        }
    }
    private func setupSearchButton() {
        addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(20)
            $0.right.equalTo(newMemoButton.snp.left).offset(-20)
        }
    }
}
