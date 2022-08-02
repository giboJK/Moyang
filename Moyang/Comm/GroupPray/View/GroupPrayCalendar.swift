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
    
    var groupCreateDate: Date!
    
    // 날짜 선택 가능 기간은 그룹의 시작날짜
    let dateLabel = UILabel().then {
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
    
    let orderButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("최근순", attributes: container)
        configuration.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        $0.configuration = configuration
    }
    let memberButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("모두", attributes: container)
        configuration.image = UIImage(systemName: "person.crop.circle.badge.checkmark")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        $0.configuration = configuration
    }
    let moveToToday = MoyangButton(.none).then {
        $0.setTitle("오늘로 이동", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setTitleColor(.nightSky1, for: .normal)
    }
    
    init(vm: VM?, groupCreateDate: Date) {
        self.vm = vm
        self.groupCreateDate = groupCreateDate
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
        setupOrderButton()
        setupMemberButton()
        setupMoveToToday()
    }
    private func setupTodayLabel() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(12)
        }
    }
    private func setupShowMoreButton() {
        addSubview(displayUnitChangeButton)
        displayUnitChangeButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(24)
            $0.centerY.equalTo(dateLabel)
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
            $0.height.equalTo(220)
            $0.left.right.equalToSuperview().inset(8)
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
        }
    }
    
    private func setupOrderButton() {
        addSubview(orderButton)
        orderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(28)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setupMemberButton() {
        addSubview(memberButton)
        memberButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(28)
            $0.left.equalTo(orderButton.snp.right).offset(12)
        }
    }
    private func setupMoveToToday() {
        addSubview(moveToToday)
        moveToToday.snp.makeConstraints {
            $0.centerY.equalTo(orderButton)
            $0.right.equalToSuperview().inset(16)
        }
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        Date()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        groupCreateDate
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        superview?.layoutIfNeeded()
    }
    
    private func toggleIsWeek(isWeek: Bool) {
        let title = isWeek ? "월 단위 변경" : "주 단위 변경"
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
        
        vm.selectDateRange(date: Date())
        
        output.isWeek
            .skip(1)
            .drive(onNext: { [weak self] isWeek in
                guard let self = self else { return }
                self.toggleIsWeek(isWeek: isWeek)
            }).disposed(by: disposeBag)
        
        output.displayDate
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        moveToToday.rx.tap
            .subscribe(onNext: { [weak self]_ in
                self?.calendar.select(Date(), scrollToDate: true)
            }).disposed(by: disposeBag)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        vm?.selectDate(date: date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        vm?.selectDateRange(date: calendar.currentPage)
    }
}
