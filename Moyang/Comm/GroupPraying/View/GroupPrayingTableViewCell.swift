//
//  GroupPrayingTableViewCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/06.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class GroupPrayingTableViewCell: UITableViewCell {
    typealias VM = GroupPrayingVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    // MARK: - UI
    let bgView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = .sheep3.withAlphaComponent(0.9)
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky3
    }
    let prayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky3
        $0.numberOfLines = 0
    }
    let divider = UIView().then {
        $0.backgroundColor = .sheep5
    }
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.register(PrayingTagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    let noTagLabel = UILabel().then {
        $0.text = "#태그"
        $0.textColor = .sheep4
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    private var isBinded = false
    var tags = [String]()
    var index: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
        contentView.backgroundColor = .clear
        
        setupUI()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI
    private func setupUI() {
        setupBgView()
        setupPrayLabel()
        setupDivider()
        setupTagCollectionView()
        setupNoTagLabel()
    }
    
    private func setupBgView() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    private func setupPrayLabel() {
        bgView.addSubview(prayLabel)
        prayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    
    private func setupDivider() {
        bgView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(prayLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(1)
        }
    }
    
    private func setupTagCollectionView() {
        bgView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    private func setupNoTagLabel() {
        bgView.addSubview(noTagLabel)
        noTagLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(4)
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
    
    func bind() {
        guard let vm = vm else {
            return
        }
        if isBinded { return }
        isBinded = true
        
        let longPress = self.rx.longPressGesture().when(.began)
            .map { [weak self] _ -> Int? in
                return self?.index
            }.asDriver(onErrorJustReturn: nil)
        
        let input = VM.Input(didLongPressPray: longPress)
        
        _ = vm.transform(input: input)
    }
}

extension GroupPrayingTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tags[indexPath.row].width(withConstraintedHeight: 16,
                                                    font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + buttonWidth, height: 28)
    }
}

extension GroupPrayingTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PrayingTagCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tags[indexPath.row]
        
        return cell
    }
}