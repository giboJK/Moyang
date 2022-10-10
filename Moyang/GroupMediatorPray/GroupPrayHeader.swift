//
//  GroupPrayCalendar.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/29.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class GroupPrayHeader: UIView {
    let myPrayLabel = UILabel().then {
        $0.text = "내 중보기도"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .sheep1
    }
    let emptyPrayContainer = UIView().then {
        $0.backgroundColor = .wilderness1.withAlphaComponent(0.8)
        $0.layer.cornerRadius = 12
    }
    let emptyPrayLabel = UILabel().then {
        $0.text = "중보기도를 요청해보세요. :)"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let prayContainer = UIView().then {
        $0.backgroundColor = .wilderness1.withAlphaComponent(0.8)
        $0.layer.cornerRadius = 12
        $0.isHidden = true
    }
    let prayLabel = UILabel().then {
        $0.text = "중보기도 주제"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let prayDateLabel = UILabel().then {
        $0.text = "yyyy. M. d"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .sheep2
        $0.numberOfLines = 0
    }
    let groupNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .sheep2
    }
    let moreButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.backgroundColor = .clear
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
        setupMyPrayLabel()
        setupEmptyPrayContainer()
        setupPrayContainer()
        setupMoreButton()
        setupSearchButton()
        setupGroupNameLabel()
    }
    private func setupMyPrayLabel() {
        addSubview(myPrayLabel)
        myPrayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupEmptyPrayContainer() {
        addSubview(emptyPrayContainer)
        emptyPrayContainer.snp.makeConstraints {
            $0.top.equalTo(myPrayLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(84)
        }
        setupEmptyPrayLabel()
    }
    
    private func setupEmptyPrayLabel() {
        emptyPrayContainer.addSubview(emptyPrayLabel)
        emptyPrayLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
    }
    private func setupPrayContainer() {
        addSubview(prayContainer)
        prayContainer.snp.makeConstraints {
            $0.top.equalTo(myPrayLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(84)
        }
        setupPrayLabel()
        setupPrayDateLabel()
    }
    private func setupPrayLabel() {
        prayContainer.addSubview(prayLabel)
        prayLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
    }
    private func setupPrayDateLabel() {
        prayContainer.addSubview(prayDateLabel)
        prayDateLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    private func setupMoreButton() {
        addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(16)
        }
        // TODO: -
        moreButton.isHidden = true
    }
    private func setupSearchButton() {
        addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(20)
            $0.right.equalToSuperview().inset(20)
        }
    }
    private func setupGroupNameLabel() {
        addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalTo(moreButton.snp.left).offset(-12)
        }
    }
}
