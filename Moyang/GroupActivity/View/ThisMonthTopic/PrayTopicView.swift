//
//  ThisMonthTopicView.swift
//  Moyang
//
//  Created by kibo on 2022/08/29.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class PrayTopicView: UIView {
    let guideLabel = UILabel().then {
        $0.text = "기도 제목을 적어보세요 +"
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 17, weight: .regular)
    }
    init() {
        super.init(frame: .zero)
        backgroundColor = .wilderness2
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setupGuideLabel()
    }
    
    private func setupGuideLabel() {
        addSubview(guideLabel)
        guideLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
