//
//  NewGroupView.swift
//  Moyang
//
//  Created by kibo on 2022/11/15.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NewGroupView: UIView {
    let label = MoyangLabel().then {
        $0.text = "공동체 만들기"
        $0.textColor = .sheep2
        $0.font = .b01
    }
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky1
        layer.cornerRadius = 12
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupLabel()
    }
    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.height.equalTo(19)
            $0.top.bottom.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
    }
}
