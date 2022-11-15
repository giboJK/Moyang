//
//  MyPrayBottomView.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit


class MyPrayBottomView: UIView {
    let typeContainer = UIView()
    let typeLabel = MoyangLabel().then {
        $0.text = "변화"
        $0.textColor = .nightSky2
        $0.font = .b03
    }
    let downImageView = UIImageView(image: UIImage(systemName: "trash")).then {
        $0.tintColor = .nightSky2
    }
    let prayButton = MoyangButton(.nightPrimary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    let textView = ChangeAnswerTextView("내용", "내용")
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .sheep2
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupPrayButton()
        setupTypeContainer()
    }
    private func setupPrayButton() {
        addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(36)
            $0.top.equalToSuperview().inset(4)
            $0.right.equalToSuperview().inset(12)
        }
    }
    private func setupTypeContainer() {
        addSubview(typeContainer)
        typeContainer.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.centerY.equalTo(prayButton)
            $0.height.equalTo(17)
        }
        setupTypeLabel()
        setupDownImageView()
    }
    private func setupTypeLabel() {
        typeContainer.addSubview(typeLabel)
        typeLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
    }
    private func setupDownImageView() {
        typeContainer.addSubview(downImageView)
        downImageView.snp.makeConstraints {
            $0.left.equalTo(typeLabel.snp.right)
            $0.top.bottom.right.equalToSuperview()
        }
    }
}

class ChangeAnswerTextView: UIView {
    let label = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .c02
        $0.isHidden = true
    }
    let textView = MoyangTextView()
    let placeholder = MoyangLabel().then {
        $0.font = .b02
        $0.textColor = .nightSky5
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

extension ChangeAnswerTextView: UITextViewDelegate {
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
