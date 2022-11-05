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
    typealias VM = MyPrayMainVC.VM
    var disposeBag: DisposeBag?
    var vm: VM?
    
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
    
    func bind() {
        guard let vm = vm, let disposeBag = disposeBag else { Log.e("vm is nil"); return }
        let input = VM.Input(toggleAlarm: myPrayAlarmView.alarmSwitch.rx.isOn
            .skip(.seconds(1), scheduler: MainScheduler.asyncInstance).asDriver(onErrorJustReturn: false))
        let output = vm.transform(input: input)
        
        output.summary
            .drive(onNext: { [weak self] summary in
                guard let self = self, let summary = summary else { return }
                guard summary.alarmID != nil,
                      let alarmTime = summary.alarmTime,
                      let isOn = summary.isOn,
                      let isSun = summary.day?.contains("0"),
                      let isMon = summary.day?.contains("1"),
                      let isTue = summary.day?.contains("2"),
                      let isWed = summary.day?.contains("3"),
                      let isThu = summary.day?.contains("4"),
                      let isFri = summary.day?.contains("5"),
                      let isSat = summary.day?.contains("6")
                else {
                    self.myPrayAlarmView.resetData()
                    return
                }
                
                self.myPrayAlarmView.setTime(data: alarmTime,
                                             isOn: isOn,
                                             isSun: isSun,
                                             isMon: isMon,
                                             isTue: isTue,
                                             isWed: isWed,
                                             isThu: isThu,
                                             isFri: isFri,
                                             isSat: isSat)
            }).disposed(by: disposeBag)
        
        // MARK: - Views
        myPrayAlarmView.alarmSwitch.rx.isOn
            .subscribe(onNext: { [weak self] isOn in
                self?.myPrayAlarmView.changeTextColor(isOn: isOn)
            }).disposed(by: disposeBag)
    }
}

class MyPrayAlarmView: UIView {
    let tabBound = UIView()
    let tabBoundTwo = UIView()
    let titleLabel = MoyangLabel().then {
        $0.text = "기도 알람"
        $0.textColor = .nightSky1
        $0.font = .b01
    }
    let alarmTimeLabel = UILabel().then {
        $0.text = "규칙적인 기도를 해보세요"
        $0.textColor = .nightSky1
        $0.font = .headline
    }
    let dayLabel = UILabel().then {
        $0.font = .b03
        $0.textColor = .nightSky2
        $0.isHidden = true
    }
    let alarmSwitch = UISwitch().then {
        $0.isHidden = true
        $0.onTintColor = .wilderness1
        $0.thumbTintColor = .sheep1
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .sheep2
        layer.cornerRadius = 12
        layer.masksToBounds = true
        setupTabBound()
        setupTabBoundTwo()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupTabBound() {
        addSubview(tabBound)
        tabBound.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.right.equalToSuperview().inset(80)
        }
    }
    private func setupTabBoundTwo() {
        addSubview(tabBoundTwo)
        tabBoundTwo.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.left.equalTo(tabBound.snp.right)
            $0.height.equalTo(60)
        }
    }
    
    private func setupUI() {
        setupTitleLabel()
        setupAlarmTimeLabel()
        setupDayLabel()
        setupAlarmSwitch()
    }
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
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
    private func setupDayLabel() {
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(alarmTimeLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setupAlarmSwitch() {
        addSubview(alarmSwitch)
        alarmSwitch.snp.makeConstraints {
            $0.top.equalToSuperview().inset(59)
            $0.right.equalToSuperview().inset(16)
        }
    }
    
    func resetData() {
        alarmSwitch.isOn = false
        alarmSwitch.isHidden = true
        dayLabel.text = ""
        dayLabel.isHidden = true
        alarmTimeLabel.text = "규칙적인 기도를 해보세요"
        alarmTimeLabel.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    func setTime(data: String, isOn: Bool, isSun: Bool, isMon: Bool, isTue: Bool, isWed: Bool, isThu: Bool, isFri: Bool, isSat: Bool) {
        if let hour = data.split(separator: ":").first, let min = data.split(separator: ":").last,
           let hourInt = Int(hour), let minInt = Int(min) {
            if hourInt > 12 {
                var timeStr = "오후 "
                timeStr += String(format: "%02d", hourInt - 12) + ":" + String(format: "%02d", minInt)
                alarmTimeLabel.text = timeStr
            } else {
                var timeStr = "오전 "
                timeStr += data
                alarmTimeLabel.text = timeStr
            }
            alarmTimeLabel.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(37)
            }
            
            alarmSwitch.isHidden = false
            alarmSwitch.isOn = isOn
            
            var dayString = ""
            dayString += isSun ? "일 " : ""
            dayString += isMon ? "월 " : ""
            dayString += isTue ? "화 " : ""
            dayString += isWed ? "수 " : ""
            dayString += isThu ? "목 " : ""
            dayString += isFri ? "금 " : ""
            dayString += isSat ? "토 " : ""
            dayLabel.isHidden = false
            dayLabel.text = dayString
            
            changeTextColor(isOn: isOn)
        }
    }
    
    func changeTextColor(isOn: Bool) {
        alarmTimeLabel.textColor = isOn ? .nightSky1 : .sheep4
        dayLabel.textColor = isOn ? .nightSky2 : .sheep4
    }
}
