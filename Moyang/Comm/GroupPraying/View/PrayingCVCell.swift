//
//  PrayingCVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/12.
//

import UIKit

class PrayingCVCell: UICollectionViewCell {
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .sheep2
    }
    let prayTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .sheep2
        $0.isEditable = false
        $0.backgroundColor = .clear
    }
    let tagDivider = UIView().then {
        $0.backgroundColor = .sheep3
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
    let noTagLabel = UILabel().then {
        $0.text = "#태그"
        $0.textColor = .nightSky3
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    var tags = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .clear
        setupDateLabel()
        setupPrayLabel()
        setupTagDivider()
        setupTagCollectionView()
        setupNoTagLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(4)
        }
    }
    private func setupPrayLabel() {
        contentView.addSubview(prayTextView)
        prayTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func setupTagDivider() {
        addSubview(tagDivider)
        tagDivider.snp.makeConstraints {
            $0.top.equalTo(prayTextView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(1)
        }
    }
    private func setupTagCollectionView() {
        addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagDivider.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(28)
        }
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    private func setupNoTagLabel() {
        addSubview(noTagLabel)
        noTagLabel.snp.makeConstraints {
            $0.top.equalTo(tagDivider.snp.bottom).offset(8)
            $0.height.equalTo(28)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    func updateTagCollectionViewHeight() {
        if tagCollectionView.visibleCells.count < tags.count {
            tagCollectionView.snp.updateConstraints {
                $0.height.equalTo(28 + 8 + 28)
            }
        } else {
            tagCollectionView.snp.updateConstraints {
                $0.height.equalTo(28)
            }
        }
    }
}

extension PrayingCVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tags[indexPath.row].width(withConstraintedHeight: 16,
                                                    font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + buttonWidth, height: 28)
    }
}

extension PrayingCVCell: UICollectionViewDataSource {
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
