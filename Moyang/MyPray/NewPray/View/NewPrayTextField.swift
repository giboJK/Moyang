//
//  NewPrayTitleView.swift
//  Moyang
//
//  Created by kibo on 2022/11/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NewPrayTextField: UIView {
    let label = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .c02
        $0.isHidden = true
    }
    let textField = MoyangTextField(.ghost, "").then {
        $0.returnKeyType = .done
        $0.enablesReturnKeyAutomatically = true
    }
    let exampleLabel = MoyangLabel().then {
        $0.textColor = .sheep3
        $0.font = .b04
    }
    
    init(_ title: String, _ example: String, _ placeholder: String? = nil) {
        super.init(frame: .zero)
        backgroundColor = .clear
        label.text = title
        if let placeholder = placeholder {
            textField.placeholder = placeholder
        } else {
            textField.placeholder = title
        }
        exampleLabel.text = example
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupLabel()
        setupTextField()
        setupExampleLabel()
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
            $0.top.equalToSuperview().inset(4 + 14)
            $0.left.right.equalToSuperview()
        }
    }
    private func setupExampleLabel() {
        addSubview(exampleLabel)
        exampleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52 + 14)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
    }
}
