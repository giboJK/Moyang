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
        $0.text = "기도제목"
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
    let myPrayTitleLabel = UILabel().then {
        $0.text = "내 기도"
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
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CommunityGroupPrayCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
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
        addSubview(myPrayTitleLabel)
        myPrayTitleLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(8)
        }
    }
    private func setupMyPrayLabel() {
        addSubview(myPrayLabel)
        myPrayLabel.snp.makeConstraints {
            $0.top.equalTo(myPrayTitleLabel.snp.bottom).offset(4)
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
            $0.left.equalToSuperview().inset(8)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(84)
        }
        prayCollectionView.delegate = self
    }
    
    func bind() {
        guard let vm = vm else { Log.e(""); return }
        let output = vm.transform(input: CommunityMainVM.Input())
        
        output.cardPrayItemList
            .drive(prayCollectionView.rx
                .items(cellIdentifier: "cell",
                       cellType: CommunityGroupPrayCollectionViewCell.self)) { (_, item, cell) in
                cell.nameLabel.text = item.name
                cell.prayLabel.text = item.pray
            }.disposed(by: disposeBag)
        
        output.myPray
            .drive(onNext: { [weak self] myPray in
                guard let myPray = myPray else { return }
                self?.myPrayLabel.text = myPray.pray
                self?.myPrayLabel.lineBreakMode = .byTruncatingTail
                self?.myLatestDateLabel.text = myPray.date
            }).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 152, height: 84)
    }
}