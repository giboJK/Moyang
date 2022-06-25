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
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.tintColor = .nightSky3
    }
    let countLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky3
    }
    
    required init(type: PrayReactionType) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
    }
    
    deinit { Log.i(self) }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        
        setupReactionButton()
        setupCountLabel()
    }
    
    private func setupReactionButton() {
        addSubview(reactionButton)
        reactionButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
            $0.bottom.top.equalToSuperview().inset(4)
        }
    }
    private func setupCountLabel() {
        addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.left.equalTo(reactionButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
        }
    }
}
