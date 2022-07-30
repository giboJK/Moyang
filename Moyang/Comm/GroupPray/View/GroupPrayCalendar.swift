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
    let myPrayLabel = UILabel()
    let myPrayContentLabel = UILabel()
    let myPrayDateLabel = UILabel()
    
    let thisWeekMyPrayTimeLabel = UILabel()
    let thisWeekMyPrayValueLabel = UILabel()
    let todayPrayTimeLabel = UILabel()
    let todayPrayValueLabel = UILabel()
    let calendar = FSCalendar()
    let filterView = UIView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .sheep1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
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
        
        calendar.headerHeight = 36
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 16, weight: .regular)
        
        calendar.snp.makeConstraints {
            $0.height.equalTo(280)
            $0.left.right.equalToSuperview().inset(8)
            $0.top.equalToSuperview().inset(12)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.layoutIfNeeded()
    }
}
