//
//  AlarmTimeView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/02.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AlarmTimeView: UIView {
    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.text = "기도"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .sheep1
    }
    let alarmView = UIView()
    let alarmLabel = UILabel().then {
        $0.text = "00:00"
        $0.font = .systemFont(ofSize: 40, weight: .semibold)
        $0.textColor = .sheep1
    }
    let ampmLabel = UILabel().then {
        $0.text = "오전"
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .sheep1
    }
    let setupButton = UIButton().then {
        $0.setTitle("  설정  ", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.backgroundColor = .nightSky2.withAlphaComponent(0.7)
        $0.layer.cornerRadius = 12
    }
    
    // MARK: - LifeCycle
    init(title: String) {
        super.init(frame: .zero)
        setupUI()
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupTitleLabel()
        setupAlarmView()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupAlarmView() {
        addSubview(alarmView)
        alarmView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(96)
        }
        let topDiveder = UIView().then {
            $0.backgroundColor = .sheep3.withAlphaComponent(0.4)
        }
        alarmView.addSubview(topDiveder)
        topDiveder.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(0.5)
        }
        let bottomDiveder = UIView().then {
            $0.backgroundColor = .sheep3.withAlphaComponent(0.4)
        }
        alarmView.addSubview(bottomDiveder)
        bottomDiveder.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(0.5)
        }
        setupAlarmLabel()
        setupAmpmLabel()
        setupSetupButton()
    }
    private func setupAlarmLabel() {
        alarmView.addSubview(alarmLabel)
        alarmLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupAmpmLabel() {
        alarmView.addSubview(ampmLabel)
        ampmLabel.snp.makeConstraints {
            $0.bottom.equalTo(alarmLabel).inset(2)
            $0.left.equalTo(alarmLabel.snp.right).offset(4)
        }
    }
    private func setupSetupButton() {
        alarmView.addSubview(setupButton)
        setupButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
            $0.height.equalTo(36)
        }
    }
    
    func setTime(data: String?, isOn: Bool?) {
        if let data = data {
            alarmLabel.text = data
            ampmLabel.isHidden = false
        } else {
            alarmLabel.text = "알람 없음"
            ampmLabel.isHidden = true
        }
        
        if let isOn = isOn {
            
        } else {
            
        }
    }
}
