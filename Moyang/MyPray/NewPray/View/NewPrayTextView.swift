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
    let textView = MoyangTextView()
    let placeholder = MoyangLabel().then {
        $0.font = .b02
        $0.textColor = .sheep3
    }
    let underLine = UIView().then {
        $0.backgroundColor = .nightSky3
    }
    
    init(_ title: String, _ placeholder: String) {
        super.init(frame: .zero)
        backgroundColor = .clear
        label.text = title
        self.placeholder.text = placeholder
        setupUI()
        textViewDidChange(textView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupLabel()
        setupTextView()
        setupPlaceholder()
        setupUnderLine()
    }
    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(8)
        }
    }
    private func setupTextView() {
        addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12 + 14)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(19)
            $0.bottom.equalToSuperview()
        }
        textView.delegate = self
    }
    private func setupPlaceholder() {
        addSubview(placeholder)
        placeholder.snp.makeConstraints {
            $0.top.equalTo(textView).inset(8)
            $0.left.equalTo(textView).inset(8)
        }
    }
    private func setupUnderLine() {
        addSubview(underLine)
        underLine.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalTo(textView)
            $0.height.equalTo(1)
        }
    }
}

extension NewPrayTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        underLine.backgroundColor = .oasis1
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        underLine.backgroundColor = .nightSky3
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.snp.updateConstraints {
            $0.height.equalTo(min(180, estimatedSize.height))
        }
    }
}
