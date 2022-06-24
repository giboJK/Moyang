//
//  ReactionPopupView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/18.
//

import UIKit

class ReactionPopupView: UIView {
    
    required init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    deinit { Log.i(self) }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        backgroundColor = .nightSky3
    }
}
