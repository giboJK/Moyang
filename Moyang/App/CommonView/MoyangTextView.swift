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
            self.setupUI()
        }
    }
    
    init(_ placeholder: String? = nil) {
        super.init(frame: .zero, textContainer: nil)
        font = .b01
        textColor = .sheep1
        
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
    
    @objc func editingBeginBorder() {
        underLine.backgroundColor = .oasis1
    }
    
    @objc func editingEndBorder() {
        underLine.backgroundColor = .nightSky3
    }
}
