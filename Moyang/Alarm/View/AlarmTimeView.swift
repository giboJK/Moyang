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
        $0.font = .systemFont(ofSize: 38, weight: .semibold)
        $0.textColor = .sheep1
    }
    let ampmLabel = UILabel().then {
        $0.text = "오전"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .sheep1
    }
    let dayLabel = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .sheep1
    }
    let setupButton = UIButton().then {
        $0.setTitle("  설정  ", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.backgroundColor = .nightSky2.withAlphaComponent(0.7)
        $0.layer.cornerRadius = 12
    }
    let alarmSwitch = UISwitch().then {
        $0.isHidden = true
    }
    let tapBounds = UIView()
    
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
        setupAlarmSwitch()
        setupTapBounds()
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
        setupDayLabel()
        setupSetupButton()
    }
    private func setupAlarmLabel() {
        alarmView.addSubview(alarmLabel)
        alarmLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-8)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupAmpmLabel() {
        alarmView.addSubview(ampmLabel)
        ampmLabel.snp.makeConstraints {
            $0.bottom.equalTo(alarmLabel).inset(6)
            $0.left.equalTo(alarmLabel.snp.right).offset(4)
        }
    }
    private func setupDayLabel() {
        alarmView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(alarmLabel.snp.bottom)
            $0.left.equalTo(alarmLabel)
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
    private func setupAlarmSwitch() {
        alarmView.addSubview(alarmSwitch)
        alarmSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
            $0.height.equalTo(36)
            $0.width.equalTo(60)
        }
    }
    
    private func setupTapBounds() {
        addSubview(tapBounds)
        tapBounds.snp.makeConstraints {
            $0.top.left.bottom.equalTo(alarmView)
            $0.right.equalToSuperview().inset(88)
        }
    }
    
    func setTime(data: String, isOn: Bool, isSun: Bool, isMon: Bool, isTue: Bool, isWed: Bool, isThu: Bool, isFri: Bool, isSat: Bool) {
        if let hour = data.split(separator: ":").first, let min = data.split(separator: ":").last,
           let hourInt = Int(hour), let minInt = Int(min) {
            
            if hourInt >= 12 {
                ampmLabel.text = "오후"
            } else {
                ampmLabel.text = "오전"
            }
            if hourInt > 12 {
                alarmLabel.text = String(format: "%02d", hourInt - 12) + ":" + String(format: "%02d", minInt)
            } else {
                alarmLabel.text = data
            }
            ampmLabel.isHidden = false
            alarmSwitch.isHidden = false
            alarmSwitch.isOn = isOn
            setupButton.isHidden = true
            
            var dayString = ""
            dayString += isSun ? "일 " : ""
            dayString += isMon ? "월 " : ""
            dayString += isTue ? "화 " : ""
            dayString += isWed ? "수 " : ""
            dayString += isThu ? "목 " : ""
            dayString += isFri ? "금 " : ""
            dayString += isSat ? "토 " : ""
            dayLabel.text = dayString
        } else {
            alarmLabel.text = "알람 없음"
            ampmLabel.isHidden = true
            alarmSwitch.isHidden = true
            setupButton.isHidden = false
        }
    }
}
