//
//  AlarmTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/09/29.
//

import UIKit
import SnapKit
import Then

class AlarmTVCell: UITableViewCell {
    // MARK: - UI
    let noAlarmLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .sheep3
        $0.isUserInteractionEnabled = false
        $0.text = "알람이 없습니다."
    }
    let timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .sheep1
        $0.isUserInteractionEnabled = false
    }
    let ampmLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .sheep1
        $0.isUserInteractionEnabled = false
    }
    let descLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .sheep1
        $0.isUserInteractionEnabled = false
    }
    let alarmSwitch = UISwitch()
    let bottomLine = UIView().then {
        $0.backgroundColor = .sheep2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .sheep1
        selectedBackgroundView = backgroundView
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI
    private func setupUI() {
        contentView.backgroundColor = .sheep1
        setupNoAlarmLabel()
        setupNameLabel()
        setupAmpmLabel()
        setupDescLabel()
        setupAlarmSwitch()
        
        setupBottomLine()
    }
    private func setupNoAlarmLabel() {
        contentView.addSubview(noAlarmLabel)
        noAlarmLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupNameLabel() {
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupAmpmLabel() {
        contentView.addSubview(ampmLabel)
        ampmLabel.snp.makeConstraints {
            $0.bottom.equalTo(timeLabel.snp.bottom).inset(4)
            $0.left.equalTo(timeLabel.snp.right).offset(4)
        }
    }
    private func setupDescLabel() {
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupAlarmSwitch() {
        contentView.addSubview(alarmSwitch)
        alarmSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(52)
        }
    }
    private func setupBottomLine() {
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview()
        }
    }
}
