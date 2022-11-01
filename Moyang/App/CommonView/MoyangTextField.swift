//
//  MoyangTextField.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import UIKit

class MoyangTextField: UITextField {
    enum MoyangTextFieldStyle {
        case sheep
        case ghost
        case none
    }
    
    var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    private var style: MoyangTextFieldStyle = .sheep
    
    private let underLine = UIView().then {
        $0.backgroundColor = .nightSky3
    }
    
    override var isEnabled: Bool {
        didSet {
            self.setupUI()
        }
    }
    
    init(_ style: MoyangTextFieldStyle = .sheep,
         _ placeholder: String? = nil,
         padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)) {
        super.init(frame: .zero)
        self.style = style
        self.padding = padding
        self.placeholder = placeholder
        font = .b01
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholder,
                                                       attributes: [.foregroundColor: UIColor.sheep3])
        }
        
        setupUI()
        addTarget(self, action: #selector(editingBeginBorder), for: .editingDidBegin)
        addTarget(self, action: #selector(editingEndBorder), for: .editingDidEnd)
        addTarget(self, action: #selector(editingEndBorder), for: .editingDidEndOnExit)
    }
    
    private func setupUI() {
        switch style {
        case .sheep:
            textColor = .nightSky1
            layer.cornerRadius = 8
            layer.masksToBounds = true
            layer.borderWidth = 1
            backgroundColor = isEnabled ? .sheep1 : .sheep3
            if let placeholder = placeholder {
                let color: UIColor = isEnabled ? .sheep3 : .sheep4
                attributedPlaceholder = NSAttributedString(string: placeholder,
                                                           attributes: [.foregroundColor: color])
            }
        case .ghost:
            textColor = .sheep1
            layer.borderWidth = 0
            setupUnderLine()
        case .none:
            break
        }
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
        switch style {
        case .sheep:
            layer.borderColor = .nightSky3
        case .ghost:
            underLine.backgroundColor = .oasis1
        case .none:
            break
        }
    }
    
    @objc func editingEndBorder() {
        switch style {
        case .sheep:
            layer.borderColor = .sheep4
        case .ghost:
            underLine.backgroundColor = .nightSky3
        case .none:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
