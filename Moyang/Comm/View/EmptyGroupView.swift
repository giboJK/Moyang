//
//  EmptyGroupView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/23.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class EmptyGroupView: UIView {
    typealias VM = CommunityMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?

    // MARK: - UI
    let helpLabel = UILabel().then {
        $0.text = "아직 공동체에 속해있지 않아요. 공동체 안에서 같이 신앙생활을 해보세요"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let askingPastorButton = MoyangButton(.secondary).then {
        $0.setTitle("공동체 요청하기", for: .normal)
    }
    
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.masksToBounds = true
        backgroundColor = .sheep2
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupHelpLabel()
        setupAskingPastorButton()
    }
    
    private func setupHelpLabel() {
        addSubview(helpLabel)
        helpLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.75)
            $0.left.right.equalToSuperview().inset(40)
        }
    }
    private func setupAskingPastorButton() {
        addSubview(askingPastorButton)
        askingPastorButton.snp.makeConstraints {
            $0.top.equalTo(helpLabel.snp.bottom).offset(16)
            $0.height.equalTo(36)
            $0.left.right.equalToSuperview().inset(48)
        }
    }
    
}
