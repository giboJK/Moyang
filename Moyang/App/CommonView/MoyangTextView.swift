//
//  MoyangTextView.swift
//  Moyang
//
//  Created by kibo on 2022/11/02.
//

import UIKit

class MoyangTextView: UITextView {
    enum MoyangTextViewStyle {
        case sheep
        case ghost
        case none
    }
    override var isEditable: Bool {
        didSet {
            self.updateUI()
        }
    }
    private var style: MoyangTextViewStyle = .sheep
    
    init(_ style: MoyangTextViewStyle = .none, padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)) {
        super.init(frame: .zero, textContainer: nil)
        
        self.style = style
        font = .b02
        textContainerInset = padding
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        if isEditable {
            textColor = .sheep1
        } else {
            textColor = .sheep4
        }
    }
    private func setupUI() {
        switch style {
        case .sheep:
            backgroundColor = .sheep1
            textColor = .nightSky1
            layer.cornerRadius = 8
            layer.masksToBounds = true
            layer.borderWidth = 1
            layer.borderColor = .sheep4
        case .ghost:
            break
        case .none:
            textColor = .sheep1
            backgroundColor = .nightSky1
        }
    }
}
