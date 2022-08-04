//
//  GroupPrayTableViewCell.swift
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

class GroupPrayTableViewCell: UITableViewCell {
    typealias VM = GroupPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var isBinded = false
    
    // MARK: - UI
    let bgView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = .sheep2
    }
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .nightSky1
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
    var userID: String = ""
    var index: Int?
    
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
        setupNameLabel()
        setupPrayCollectionView()
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
    }
    
    func bind() {
        if let vm = vm {
            if isBinded { return }
            isBinded = true
            
            let output = vm.transform(input: VM.Input())
            output.memberPrayList
                .map { $0[self.userID] ?? [] }
                .drive(prayCollectionView.rx
                    .items(cellIdentifier: "cell", cellType: PrayCVCell.self)) { [weak self] (index, item, cell) in
                        cell.userID = self!.userID
                        cell.row = index
                        cell.setupData(item: item)
                    }.disposed(by: disposeBag)
            
            output.memberPrayList
                .map { $0[self.userID] ?? [] }
                .map { $0.isEmpty }
                .drive(onNext: { [weak self] isEmpty in
                    guard let self = self else { return }
                    if isEmpty {
                        self.prayCollectionView.snp.remakeConstraints {
                            $0.top.equalTo(self.nameLabel.snp.bottom)
                            $0.left.right.bottom.equalToSuperview()
                            $0.height.equalTo(0)
                        }
                    } else {
                        self.prayCollectionView.snp.remakeConstraints {
                            $0.top.equalTo(self.nameLabel.snp.bottom)
                            $0.left.right.bottom.equalToSuperview()
                            $0.height.equalTo(200)
                        }
                    }
                }).disposed(by: disposeBag)
        }
    }
}

extension GroupPrayTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.8, height: 200)
    }
}
