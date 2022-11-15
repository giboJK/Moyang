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
    
    init(padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)) {
        super.init(frame: .zero, textContainer: nil)
        font = .b02
        textColor = .sheep1
        textContainerInset = padding
        backgroundColor = .nightSky1
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
}
