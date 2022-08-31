//
//  PrayReactionView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/18.
//

import UIKit

class PrayReactionView: UIView {
    
    var type: PrayReactionType = .love
    
    let reactionButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setTitleColor(.nightSky3, for: .normal)
        $0.tintColor = .nightSky3
        $0.isUserInteractionEnabled = false
    }
    
    required init(type: PrayReactionType, count: Int) {
        self.type = type
        reactionButton.setTitle("\(type.desc) \(count)", for: .normal)
        
        super.init(frame: .zero)
        setupUI()
    }
    
//    deinit { Log.i(self) }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupReactionButton()
    }
    
    private func setupReactionButton() {
        addSubview(reactionButton)
        reactionButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
