//
//  CommunityGroupPrayCard.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class CommunityGroupPrayCard: UIView {
    
    // MARK: - UI
    let titleLabel = UILabel()
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .medium)
    lazy var nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.right", withConfiguration: largeConfig), for: .normal)
        $0.tintColor = .sheep1
    }
    let divider = UIView()
    let myPrayTitleLabel = UILabel()
    let myPrayLabel = UILabel()
    let myLatestDateLabel = UILabel()
    let groupPrayTitleLabel = UILabel()
    let groupPrayLabel = UILabel()
    let groupLatestDateLabel = UILabel()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        dropShadow()
    }
}
