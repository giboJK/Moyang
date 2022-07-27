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
    var vm: CommunityMainVM?
    
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
        $0.text = "이번주"
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.tintColor = .nightSky1
    }
    let myPrayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.tintColor = .nightSky1
        $0.numberOfLines = 2
    }
    let myLatestDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    let groupPrayTitleLabel = UILabel().then {
        $0.text = "멤버 기도"
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.tintColor = .nightSky1
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
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = .sheep1
        setupTitleLabel()
        setupNextButton()
        setupDivider()
        setupMyPrayTitleLabel()
        setupMyPrayLabel()
        setupMyLatestDateLabel()
        setupGroupPrayTitleLabel()
        setupPrayCollectionView()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(8)
        }
    }
    private func setupNextButton() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(8)
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
    private func setupMyPrayTitleLabel() {
        addSubview(thisWeekLabel)
        thisWeekLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(8)
        }
    }
    private func setupMyPrayLabel() {
        addSubview(myPrayLabel)
        myPrayLabel.snp.makeConstraints {
            $0.top.equalTo(thisWeekLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
        }
    }
    private func setupMyLatestDateLabel() {
        addSubview(myLatestDateLabel)
        myLatestDateLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(4)
            $0.right.equalToSuperview().inset(8)
        }
    }
    private func setupGroupPrayTitleLabel() {
        addSubview(groupPrayTitleLabel)
        groupPrayTitleLabel.snp.makeConstraints {
            $0.top.equalTo(myPrayLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(8)
        }
    }
    private func setupPrayCollectionView() {
        addSubview(prayCollectionView)
        prayCollectionView.snp.makeConstraints {
            $0.top.equalTo(groupPrayTitleLabel.snp.bottom).offset(4)
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
                                Log.w(date.toString("yyyy년 MM월 dd일 hh:mmZ"))
                                cell.dateLabel.text = date.toString("yyyy년 MM월 dd일 hh:mm a")
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
        
        output.myPray
            .drive(onNext: { [weak self] myPray in
                guard let myPray = myPray else { return }
                self?.myPrayLabel.text = myPray.pray
                self?.myPrayLabel.lineBreakMode = .byTruncatingTail
                self?.myLatestDateLabel.text = myPray.createDate
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16 - 36, height: 160)
    }
}
