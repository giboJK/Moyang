//
//  GroupPrayTVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class GroupPrayTVCell: UITableViewCell {
    typealias VM = GroupPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    weak var vm: VM?
    var isBinded = false
    
    // MARK: - UI
    let bgView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
    }
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
    }
    let prayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PrayCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
    let emptyPrayView = UIView().then {
        $0.backgroundColor = .nightSky1
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.isHidden = true
    }
    let emptyPrayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep2
        $0.text = "기도 제목이 없습니다."
    }
    let divider = UIView().then {
        $0.backgroundColor = .sheep3
    }
    
    var userID: String = ""
    var prayID: String = ""
    var prayList = [GroupIndividualPray]()
    
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
        setupNameLabel()
        setupPrayCollectionView()
        setupEmptyPrayView()
        setupDivider()
    }
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupPrayCollectionView() {
        contentView.addSubview(prayCollectionView)
        prayCollectionView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
        prayCollectionView.delegate = self
        prayCollectionView.dataSource = self
    }
    
    private func setupEmptyPrayView() {
        setupEmptyPrayLabel()
    }
    private func setupEmptyPrayLabel() {
        emptyPrayView.addSubview(emptyPrayLabel)
        emptyPrayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(12)
        }
    }
    
    private func setupDivider() {
        contentView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(12)
            $0.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    private func bindViews() {
        prayCollectionView.rx.contentOffset
            .skip(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .throttle(.milliseconds(400), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                let offset = self.prayCollectionView.contentOffset.y
                let maxOffset = self.prayCollectionView.contentSize.height - self.prayCollectionView.frame.size.height
                if maxOffset - offset <= 0 {
                    self.vm?.fetchMorePrays(userID: self.userID)
                }
            }).disposed(by: disposeBag)
    }
    
    func bind() {
        if let vm = vm {
            prayList = vm.memberPrayList.value[userID] ?? []
            prayCollectionView.reloadData()
            let isEmptyList = prayList.isEmpty
            
            if isEmptyList {
                prayCollectionView.snp.remakeConstraints {
                    $0.top.equalTo(nameLabel.snp.bottom)
                    $0.left.right.bottom.equalToSuperview()
                    $0.height.equalTo(40)
                }
                if emptyPrayView.superview == nil {
                    contentView.addSubview(emptyPrayView)
                    emptyPrayView.snp.remakeConstraints {
                        $0.top.equalTo(nameLabel.snp.bottom)
                        $0.left.right.bottom.equalToSuperview()
                        $0.height.equalTo(40)
                    }
                }
                emptyPrayView.isHidden = false
            } else {
                prayCollectionView.snp.remakeConstraints {
                    $0.top.equalTo(nameLabel.snp.bottom)
                    $0.left.right.bottom.equalToSuperview()
                    $0.height.equalTo(200)
                }
                emptyPrayView.removeFromSuperview()
                emptyPrayView.isHidden = true
            }
            
            if isBinded { return }
            isBinded = true
            let showPrayDetail = prayCollectionView.rx.itemSelected.map { (self.userID, $0) }.asDriver(onErrorJustReturn: nil)
            let input = VM.Input(showPrayDetail: showPrayDetail)
            let output = vm.transform(input: input)

            output.memberPrayList
                .map { $0[self.userID] ?? [] }
                .drive(onNext: { [weak self] list in
                    self?.prayList = list
                    self?.prayCollectionView.reloadData()
                }).disposed(by: disposeBag)
        }
    }
}

extension GroupPrayTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.8, height: 200)
    }
}

extension GroupPrayTVCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = prayCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PrayCVCell
        cell.userID = userID
        cell.row = indexPath.row
        cell.setupData(item: prayList[indexPath.row])
        cell.vm = vm
        cell.bind()
        return cell
    }
}
