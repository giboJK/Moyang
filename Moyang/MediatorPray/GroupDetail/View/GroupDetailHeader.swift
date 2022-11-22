//
//  GroupDetailHeader.swift
//  Moyang
//
//  Created by kibo on 2022/11/18.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class GroupDetailHeader: UIView {
    typealias VM = GroupDetailVM
    var disposeBag: DisposeBag?
    var vm: VM?
    
    // MARK: - UI
    let newMediatorView = NewMediatorView()
    let requestMediatorView = RequestMediatorView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupNewMediatorView()
        setupRequestMediatorView()
    }
    private func setupNewMediatorView() {
        addSubview(newMediatorView)
        newMediatorView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(89)
        }
    }
    private func setupRequestMediatorView() {
        addSubview(requestMediatorView)
        requestMediatorView.snp.makeConstraints {
            $0.top.equalTo(newMediatorView.snp.bottom).offset(28)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(28)
            $0.height.equalTo(89)
        }
    }
}

class NewMediatorView: UIView {
    // MARK: - UI
    let titleLabel = MoyangLabel().then {
        $0.text = "중보기도 올리기"
        $0.textColor = .sheep1
        $0.font = .b01
    }
    let subLabel = MoyangLabel().then {
        $0.text = "공동체와 함께 더 큰 은혜를 누리세요"
        $0.textColor = .sheep3
        $0.font = .b05
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
        backgroundColor = .nightSky4
        layer.cornerRadius = 12
        setupTitleLabel()
        setupSubLabel()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(19)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupSubLabel() {
        addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}

class RequestMediatorView: UIView {
    // MARK: - UI
    let titleLabel = MoyangLabel().then {
        $0.text = "번개기도 요청"
        $0.textColor = .wilderness1
        $0.font = .b01
    }
    let subLabel = MoyangLabel().then {
        $0.text = "각자의 자리에서 같이 기도할까요?"
        $0.textColor = .sheep3
        $0.font = .b05
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
        backgroundColor = .nightSky4
        layer.cornerRadius = 12
        setupTitleLabel()
        setupSubLabel()
    }
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(19)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupSubLabel() {
        addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}
