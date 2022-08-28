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
    let addPrayButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("새 기도", attributes: container)
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        $0.configuration = configuration
    }
    let prayButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("기도하기", attributes: container)
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        $0.configuration = configuration
    }
    let searchButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("검색", attributes: container)
        configuration.image = UIImage(systemName: "magnifyingglass")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .nightSky3
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        $0.configuration = configuration
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
        setupAddPrayButton()
        setupPrayButton()

        setupSearchButton()
    }
    private func setupAddPrayButton() {
        addSubview(addPrayButton)
        addPrayButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(36)
            $0.left.equalToSuperview().inset(20)
        }
    }
    private func setupPrayButton() {
        addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(36)
            $0.left.equalTo(addPrayButton.snp.right).offset(12)
        }
    }

    private func setupSearchButton() {
        addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(36)
            $0.right.equalToSuperview().inset(20)
        }
    }
}
