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

class ThisMonthTopicView: UIView {
    let thisMonthGuideLabel = UILabel().then {
        $0.text = "이번 달 기도할 주제를 적어보세요"
    }
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        
    }
}
