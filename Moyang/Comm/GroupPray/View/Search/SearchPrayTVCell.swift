//
//  SearchPrayTVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/24.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class SearchPrayTVCell: UITableViewCell {
    // MARK: - UI
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
        $0.isUserInteractionEnabled = false
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .nightSky2
        $0.isUserInteractionEnabled = false
    }
    let prayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
        $0.isUserInteractionEnabled = false
        $0.numberOfLines = 3
    }
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.register(PrayTagCVCell.self, forCellWithReuseIdentifier: "cell")
    }
    let bottomLine = UIView().then {
        $0.backgroundColor = .sheep2
    }
    
    var tags = [String]()
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
        setupDateLabel()
        setupPrayLabel()
        setupTagCollectionView()
        
        setupBottomLine()
    }
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupPrayLabel() {
        contentView.addSubview(prayLabel)
        prayLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(36)
        }
    }
    private func setupTagCollectionView() {
        contentView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.bottom.equalToSuperview().inset(24)
            $0.left.right.equalToSuperview()
        }
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    private func setupBottomLine() {
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview()
        }
    }
}


extension SearchPrayTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tags[indexPath.row].width(withConstraintedHeight: 16,
                                                    font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + buttonWidth, height: 28)
    }
}

extension SearchPrayTVCell: UICollectionViewDataSource {
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
