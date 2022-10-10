//
//  WorshipNoteTVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class WorshipNoteTVCell: UITableViewCell {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    weak var vm: VM?
    var isBinded = false
    
    // MARK: - UI
    let bgView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
    }
    let pastorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
    }
    let bibleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
    }
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
        $0.numberOfLines = 2
    }
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
        $0.numberOfLines = 0
    }
    let tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PrayCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
    let divider = UIView().then {
        $0.backgroundColor = .sheep3.withAlphaComponent(0.7)
    }
    
    var userID: String = ""
    var tagList = [String]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .nightSky1
        selectedBackgroundView = backgroundView
        
        setupUI()
        bindViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI
    private func setupUI() {
        contentView.backgroundColor = .nightSky1
        setupPastorLabel()
        setupBibleLabel()
        setupDateLabel()
        setupTitleLabel()
        setupContentLabel()
        setupTagCollectionView()
        setupDivider()
    }
    private func setupPastorLabel() {
        contentView.addSubview(pastorLabel)
        pastorLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupBibleLabel() {
        contentView.addSubview(bibleLabel)
        bibleLabel.snp.makeConstraints {
            $0.top.equalTo(pastorLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            
        }
    }
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(bibleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func setupContentLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupTagCollectionView() {
        contentView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    private func setupDivider() {
        contentView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(12)
            $0.right.equalToSuperview()
            $0.height.equalTo(0.3)
        }
    }
    
    private func bindViews() {
        tagCollectionView.rx.contentOffset
            .skip(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .throttle(.milliseconds(400), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                let offset = self.tagCollectionView.contentOffset.y
                let maxOffset = self.tagCollectionView.contentSize.height - self.tagCollectionView.frame.size.height
                if maxOffset - offset <= 0 {
                    self.vm?.fetchMorePrays(userID: self.userID)
                }
            }).disposed(by: disposeBag)
    }
    
    func bind() {
        if let vm = vm {
            tagCollectionView.reloadData()
            
            if isBinded { return }
            isBinded = true
            let showPrayDetail = tagCollectionView.rx.itemSelected.map { (self.userID, $0) }.asDriver(onErrorJustReturn: nil)
            let input = VM.Input(showPrayDetail: showPrayDetail)
            let output = vm.transform(input: input)

//            output.memberPrayList
//                .map { $0[self.userID] ?? [] }
//                .drive(onNext: { [weak self] list in
//                    self?.prayCollectionView.reloadData()
//                }).disposed(by: disposeBag)
        }
    }
}

extension WorshipNoteTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.8, height: 200)
    }
}

extension WorshipNoteTVCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                                for: indexPath) as? PrayCVCell else { return UICollectionViewCell() }
        cell.row = indexPath.row
//        cell.setupData(item: tagList[indexPath.row])
        return cell
    }
}
