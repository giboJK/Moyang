//
//  MyPrayTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/10/19.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class MyPrayTVCell: UITableViewCell {
    typealias VM = MyPrayMainVM
    var disposeBag: DisposeBag = DisposeBag()
    weak var vm: VM?
    
    // MARK: - UI
    let bgView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
    }
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
        $0.numberOfLines = 2
    }
    let tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PrayTagCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
    let divider = UIView().then {
        $0.backgroundColor = .sheep3.withAlphaComponent(0.5)
    }
    
    var tags = [String]()
    var row: Int!
    var isBinded = false
    
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
        setupTitleLabel()
        setupTagCollectionView()
        setupDivider()
    }
    private func setupTitleLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupTagCollectionView() {
        contentView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.left.right.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(28)
        }
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    private func setupDivider() {
        contentView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func updateUI() {
        tagCollectionView.snp.updateConstraints {
            if tags.isEmpty {
                $0.height.equalTo(0)
            } else {
                $0.height.equalTo(28)
            }
        }
    }
    
    private func bindViews() {
    }
    
    func bind() {
    }
}

extension MyPrayTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tags[indexPath.row].width(withConstraintedHeight: 16,
                                                    font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + buttonWidth, height: 28)
    }
}

extension MyPrayTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PrayTagCVCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tags[indexPath.row]
        
        return cell
    }
}
