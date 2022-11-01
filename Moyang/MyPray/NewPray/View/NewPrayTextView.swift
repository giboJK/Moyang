//
//  NewPrayTextView.swift
//  Moyang
//
//  Created by kibo on 2022/11/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NewPrayTextView: UIView {
    let label = MoyangLabel().then {
        $0.textColor = .sheep3
        $0.font = .c02
        $0.isHidden = true
    }
    let textField = MoyangTextField(.ghost, "제목").then {
        $0.returnKeyType = .done
        $0.enablesReturnKeyAutomatically = true
    }
    
    init(_ title: String) {
        super.init(frame: .zero)
        backgroundColor = .clear
        label.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupLabel()
        setupTextField()
    }
    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(8)
        }
    }
    private func setupTextField() {
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12 + 14)
            $0.left.right.equalToSuperview()
        }
    }
}
