//
//  MyPrayHabitView.swift
//  Moyang
//
//  Created by kibo on 2022/11/01.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class MyPrayHabitView: UIView {
    let myHabitLabel = MoyangLabel().then {
        $0.text = "내 기도 습관"
        $0.textColor = .sheep1
        $0.font = .headline
    }
    let myPrayAlarmView = MyPrayAlarmView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupMyHabitLabel()
        setupMyPrayAlarmView()
    }
    private func setupMyHabitLabel() {
        addSubview(myHabitLabel)
        myHabitLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
        }
    }
    private func setupMyPrayAlarmView() {
        addSubview(myPrayAlarmView)
        myPrayAlarmView.snp.makeConstraints {
            $0.top.equalTo(myHabitLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}

class MyPrayAlarmView: UIView {
    let forwardImageView = UIImageView(image: UIImage(systemName: "chevron.forward")).then {
        $0.tintColor = .sheep3
    }
    let titleLabel = MoyangLabel().then {
        $0.text = "기도 알람"
        $0.textColor = .nightSky1
        $0.font = .b01
    }
    let alarmTimeLabel = MoyangLabel().then {
        $0.text = "규칙적인 기도를 해보세요"
        $0.textColor = .nightSky3
        $0.font = .headline
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .sheep2
        layer.cornerRadius = 12
        layer.masksToBounds = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupTitleLabel()
        setupForwardImageView()
        setupAlarmTimeLabel()
    }
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setupForwardImageView() {
        addSubview(forwardImageView)
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(10)
            $0.height.equalTo(16)
        }
    }
    private func setupAlarmTimeLabel() {
        addSubview(alarmTimeLabel)
        alarmTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
