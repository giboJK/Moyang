//
//  GroupPrayCalendar.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/29.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit
import FSCalendar

class GroupPrayCalendar: UIView, FSCalendarDelegate, FSCalendarDataSource {
    typealias VM = GroupPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    // 날짜 선택 가능 기간은 그룹의 시작날짜
    let todayLabel = UILabel().then {
        $0.text = Date().toString("yyyy년 M월 d일")
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let displayUnitChangeButton = UIButton().then {
        $0.setTitle("월 별로 보기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.setTitleColor(.nightSky1, for: .normal)
    }
    let thisWeekMyPrayTimeLabel = UILabel()
    let thisWeekMyPrayValueLabel = UILabel()
    let todayPrayTimeLabel = UILabel()
    let todayPrayValueLabel = UILabel()
    let calendar = FSCalendar()
    
    let myPrayLabel = UILabel()
    let myPrayContentLabel = UILabel()
    let myPrayDateLabel = UILabel()
    
    let filterView = UIView()
    
    init(vm: VM?) {
        self.vm = vm
        super.init(frame: .zero)
        backgroundColor = .sheep1
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupTodayLabel()
        setupShowMoreButton()
        setupCalendar()
    }
    private func setupTodayLabel() {
        addSubview(todayLabel)
        todayLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(12)
        }
    }
    private func setupShowMoreButton() {
        addSubview(displayUnitChangeButton)
        displayUnitChangeButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(24)
            $0.centerY.equalTo(todayLabel)
        }
    }
    
    private func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        
        addSubview(calendar)
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.weekdayTextColor = .nightSky1
        calendar.appearance.headerTitleColor = .nightSky1
        calendar.appearance.selectionColor = .ydGreen2
        calendar.appearance.todayColor = .ydGreen1
        calendar.appearance.todaySelectionColor = .black

        calendar.headerHeight = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 16, weight: .regular)
        
        calendar.snp.makeConstraints {
            $0.height.equalTo(240)
            $0.left.right.equalToSuperview().inset(8)
            $0.top.equalTo(todayLabel.snp.bottom).offset(12)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        Log.w("dadsmsaklsmaldkm")
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        superview?.layoutIfNeeded()
    }
    
    private func toggleIsWeek(isWeek: Bool) {
        let title = isWeek ? "월 별로 보기" : "주 별로 보기"
        displayUnitChangeButton.setTitle(title, for: .normal)
        let scope = isWeek ? FSCalendarScope.week : FSCalendarScope.month
        calendar.setScope(scope, animated: true)
        displayUnitChangeButton.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.displayUnitChangeButton.isUserInteractionEnabled = true
        }
    }
    
    func bind() {
        guard let vm = vm else {
            return
        }
        let input = VM.Input(toggleIsWeek: displayUnitChangeButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.isWeek
            .skip(1)
            .drive(onNext: { [weak self] isWeek in
                self?.toggleIsWeek(isWeek: isWeek)
            }).disposed(by: disposeBag)
    }
}
