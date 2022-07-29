//
//  CommunityGroupPrayCard.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class CommunityGroupPrayCard: UIView, UICollectionViewDelegateFlowLayout {
    typealias VM = CommunityMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.text = "기도"
        $0.textColor = .nightSky1
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .medium)
    lazy var nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.right", withConfiguration: largeConfig), for: .normal)
        $0.tintColor = .nightSky1
    }
    let divider = UIView().then {
        $0.backgroundColor = .sheep3
    }
    let thisWeekLabel = UILabel().then {
        let date = Date()
        if let start = date.startOfWeek, let end = date.endOfWeek {
            $0.text = "\(start.toString("MM월 dd일")) - \(end.toString("MM월 dd일"))"
        } else {
            $0.text = "이번주"
        }
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let prayGoalLabel = UILabel().then {
        $0.text = "1,000 분"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let praySlider = UISlider().then {
        $0.backgroundColor = .clear
        $0.tintColor = .ydGreen1
        $0.setThumbImage(UIImage(), for: .normal)
        $0.setValue(0.0, animated: true)
        $0.layer.cornerRadius = 8
        $0.setMaximumTrackImage(Asset.Images.Pray.sliderEmpty.image, for: .normal)
        $0.setMinimumTrackImage(Asset.Images.Pray.sliderFill.image, for: .normal)
    }
    let myLatestPrayDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky2
    }
    let prayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CommunityGroupPrayCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        return cv
    }()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupTimer()
        bindViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        backgroundColor = .sheep1
        setupTitleLabel()
        setupNextButton()
        setupDivider()
        setupThisWeekLabel()
        setupPrayGoalLabel()
        setupPraySlider()
        setupMyLatestDateLabel()
        setupPrayCollectionView()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalToSuperview().inset(12)
        }
    }
    private func setupNextButton() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(12)
            $0.size.equalTo(16)
        }
    }
    private func setupDivider() {
        addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    private func setupThisWeekLabel() {
        addSubview(thisWeekLabel)
        thisWeekLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(12)
        }
    }
    private func setupPrayGoalLabel() {
        addSubview(prayGoalLabel)
        prayGoalLabel.snp.makeConstraints {
            $0.top.equalTo(thisWeekLabel.snp.bottom).offset(8)
            $0.right.equalToSuperview().inset(20)
        }
    }
    private func setupPraySlider() {
        addSubview(praySlider)
        praySlider.snp.makeConstraints {
            $0.top.equalTo(prayGoalLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(16)
        }
    }
    private func setupMyLatestDateLabel() {
        addSubview(myLatestPrayDateLabel)
        myLatestPrayDateLabel.snp.makeConstraints {
            $0.top.equalTo(praySlider.snp.bottom).offset(12)
            $0.right.equalToSuperview().inset(12)
        }
    }
    private func setupPrayCollectionView() {
        addSubview(prayCollectionView)
        prayCollectionView.snp.makeConstraints {
            $0.top.equalTo(myLatestPrayDateLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(160)
        }
        prayCollectionView.delegate = self
    }
    
    var carouselTimer: Timer?
    var current = 0
    var cardCount = 0
    private func setupTimer() {
        carouselTimer?.invalidate()
        carouselTimer = nil
        carouselTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.cardCount == 0 { return }
            self.current = min(self.current + 1, self.cardCount)
            if self.cardCount == self.current {
                self.current = 0
            }
            self.prayCollectionView.scrollToItem(at: IndexPath(row: self.current, section: 0),
                                                 at: .top, animated: true)
        }
    }
    
    func bind() {
        guard let vm = vm else { Log.e(""); return }
        let output = vm.transform(input: CommunityMainVM.Input())
        
        output.cardPrayItemList
            .drive(prayCollectionView.rx
                .items(cellIdentifier: "cell",
                       cellType: CommunityGroupPrayCollectionViewCell.self)) { (_, item, cell) in
                cell.nameLabel.text = item.name
                if let pray = item.pray {
                    if !(item.isSecret ?? false) {
                        cell.prayLabel.text = pray
                        if let isoDate = item.createDate, let removeMilliSec = isoDate.split(separator: ".").first {
                            let timeString = String(removeMilliSec)+"+00:00"
                            let formatter = DateFormatter()
                            formatter.locale = .current
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            formatter.timeZone = TimeZone.current
                            if let date = formatter.date(from: timeString) {
                                cell.dateLabel.text = date.toString("yyyy년 MM월 dd일 hh:mm a")
                                cell.newView.isHidden = !Calendar.current.isDateInThisWeek(date)
                            }
                        }
                    } else {
                        cell.prayLabel.text = "기도제목이 없습니다"
                    }
                } else {
                    cell.prayLabel.text = "기도제목이 없습니다"
                }
            }.disposed(by: disposeBag)
        
        output.cardPrayItemList.map { $0.count }
            .drive(onNext: { [weak self] count in
                self?.cardCount = count
            }).disposed(by: disposeBag)
        
        output.latestPrayDate
            .map { "내 최근 기도일: " + $0 }
            .drive(myLatestPrayDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(output.prayGoalValue,
                             output.prayProgressValue)
        .drive(onNext: { [weak self] (goal, progress) in
            guard let self = self else { return }
            let sliderValue = min(Float(Double(progress) / Double(goal)), 1.0)
            self.praySlider.setValue(sliderValue, animated: true)
            self.prayGoalLabel.text = progress.withCommas() + "분 / " + goal.withCommas() + "분"
        }).disposed(by: disposeBag)
    }
    
    func bindViews() {
        prayCollectionView.rx.didScroll.debounce(.milliseconds(20), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.prayCollectionView.isUserInteractionEnabled = true
                self?.setupTimer()
            }).disposed(by: disposeBag)
        
        prayCollectionView.rx.didEndDisplayingCell
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.prayCollectionView.isUserInteractionEnabled = false
            }).disposed(by: disposeBag)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16 - 36, height: 160)
    }
}
