//
//  MoyangTextView.swift
//  Moyang
//
//  Created by kibo on 2022/11/02.
//

import UIKit

class MoyangTextView: UITextView {
    private let underLine = UIView().then {
        $0.backgroundColor = .nightSky3
    }
        
    override var isEditable: Bool {
        didSet {
            self.updateUI()
        }
    }
    
    init(_ placeholder: String? = nil, padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)) {
        super.init(frame: .zero, textContainer: nil)
        font = .b02
        textColor = .sheep1
        textContainerInset = padding
        
        setupUI()
        
//        addTarget(self, action: #selector(editingBeginBorder), for: .editingDidBegin)
//        addTarget(self, action: #selector(editingEndBorder), for: .editingDidEnd)
//        addTarget(self, action: #selector(editingEndBorder), for: .editingDidEndOnExit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        setupUnderLine()
    }
    
    private func setupUnderLine() {
        addSubview(underLine)
        underLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func updateUI() {
        if isEditable {
            textColor = .sheep1
        } else {
            textColor = .sheep4
        }
    }
    
    @objc func editingBeginBorder() {
        underLine.backgroundColor = .oasis1
    }
    
    @objc func editingEndBorder() {
        underLine.backgroundColor = .nightSky3
    }
}
