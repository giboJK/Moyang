//
//  GroupReqCheckTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/11/25.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class GroupReqCheckTVCell: UITableViewCell {
    typealias VM = GroupDetailVM
    var vm: VM?
    var isBinded = false
    
    let container = UIView().then {
        $0.backgroundColor = .nightSky3
        $0.layer.cornerRadius = 12
    }
    let nameLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .b01
    }
    let reqDateLabel = MoyangLabel().then {
        $0.textColor = .sheep2
        $0.font = .b01
    }
    let acceptButton = MoyangButton(.nightPrimary).then {
        $0.setTitle("승낙", for: .normal)
    }
    let denialButton = MoyangButton(.warning).then {
        $0.setTitle("거절", for: .normal)
    }
    var index = -1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        setupContentView()
        setupContainer()
    }
    private func setupContentView() {
        contentView.backgroundColor = .nightSky1
    }
    private func setupContainer() {
        contentView.addSubview(container)
        container.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(20)
        }
        setupNameLabel()
        setupReqDateLabel()
        setupDenialButton()
        setupAcceptButton()
    }
    private func setupNameLabel() {
        container.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.height.equalTo(19)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setupReqDateLabel() {
        container.addSubview(reqDateLabel)
        reqDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.height.equalTo(19)
            $0.right.equalToSuperview().inset(16)
        }
    }
    private func setupDenialButton() {
        container.addSubview(denialButton)
        denialButton.snp.makeConstraints {
            $0.top.equalTo(reqDateLabel.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(28)
            $0.width.equalTo(68)
            $0.right.equalToSuperview().inset(16)
        }
    }
    private func setupAcceptButton() {
        container.addSubview(acceptButton)
        acceptButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.right.equalTo(denialButton.snp.left).offset(-12)
            $0.height.equalTo(28)
            $0.width.equalTo(68)
        }
    }
    func bind() {
        if let vm = vm {
            if isBinded { return }
            isBinded = true
            
            let input = VM.Input(acceptItem: acceptButton.rx.tap
                .map { [weak self] _ in
                    return self?.index ?? -1
                }
                .asDriver(onErrorJustReturn: -1),
                                 denyItem: denialButton.rx.tap
                .map { [weak self] _ in
                    return self?.index ?? -1
                }
                .asDriver(onErrorJustReturn: -1)
            )
            _ = vm.transform(input: input)
        }
    }
}
