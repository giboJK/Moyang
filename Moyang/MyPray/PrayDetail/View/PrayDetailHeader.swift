//
//  PrayDetailHeader.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class PrayDetailHeader: UIView {
    let titleLabel = MoyangLabel().then {
        $0.text = "제목"
        $0.textColor = .sheep3
        $0.font = .b03
    }
    let titleTextField = MoyangTextField(.sheep)
    let mediatorLabel = MoyangLabel().then {
        $0.text = "중보기도"
        $0.textColor = .sheep3
        $0.font = .b03
    }
    let mediatorTextField = MoyangTextField(.sheep)
    let recordButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("기록하기", for: .normal)
    }
    let changeAndAnswerLabel = MoyangLabel().then {
        $0.text = "변화나 응답이 있나요?"
        $0.textColor = .wilderness1
        $0.font = .b01
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
        setupTitleLabel()
        setupTitleTextField()
        setupMediatorLabel()
        setupMediatorTextField()
        setupRecordButton()
        setupChangeAndAnswerLabel()
    }
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(17)
        }
    }
    private func setupTitleTextField() {
        addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
    private func setupMediatorLabel() {
        addSubview(mediatorLabel)
        mediatorLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupMediatorTextField() {
        addSubview(mediatorTextField)
        mediatorTextField.snp.makeConstraints {
            $0.top.equalTo(mediatorLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
    private func setupRecordButton() {
        addSubview(recordButton)
        recordButton.snp.makeConstraints {
            $0.width.equalTo(92)
            $0.height.equalTo(36)
            $0.top.equalTo(mediatorTextField.snp.bottom).offset(24)
            $0.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    private func setupChangeAndAnswerLabel() {
        addSubview(changeAndAnswerLabel)
        changeAndAnswerLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24)
            $0.centerY.equalTo(recordButton)
        }
    }
}

