//
//  MoyangTextField.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import UIKit

class MoyangTextField: UITextField {
    var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    init(padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)) {
        super.init(frame: .zero)
        self.padding = padding
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
