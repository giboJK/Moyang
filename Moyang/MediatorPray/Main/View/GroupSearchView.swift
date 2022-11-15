//
//  GroupSearchView.swift
//  Moyang
//
//  Created by kibo on 2022/11/01.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class GroupSearchView: UIView {
    let label = MoyangLabel().then {
        $0.text = "공동체 찾기"
        $0.textColor = .sheep2
        $0.font = .b01
    }
    let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass")).then {
        $0.tintColor = .sheep1
    }
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky3
        layer.cornerRadius = 12
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupLabel()
        setupImageView()
    }
    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.height.equalTo(19)
            $0.top.bottom.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.size.equalTo(20)
        }
    }
}
