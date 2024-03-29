//
//  ActivityTabView.swift
//  Moyang
//
//  Created by kibo on 2022/09/07.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ActivityTabView: UIView {
    typealias VM = ActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    let menuCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TabMenuCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.allowsMultipleSelection = false
        cv.isMultipleTouchEnabled = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        return cv
    }()
    
    enum TapMenu: Int, CaseIterable {
//        case qt
        case pray
//        case worshipNote
        case mediatorPray
//        case thanks
        
        var addActionTitle: String {
            switch self {
            case .mediatorPray:
                return "새 중보기도"
//            case .qt:
//                return "새 묵상"
            case .pray:
                return "새 기도"
//            case .worshipNote:
//                return "새 예배노트"
//            case .thanks:
//                return "새 감사"
            }
        }
        
        var tabTitle: String {
            switch self {
            case .mediatorPray:
                return "중보 기도"
//            case .qt:
//                return "말씀 묵상"
            case .pray:
                return "내 기도"
//            case .worshipNote:
//                return "예배노트"
//            case .thanks:
//                return "한 줄 감사"
            }
        }
    }
    var tabMenus: [TapMenu]
    
    init() {
        tabMenus = TapMenu.allCases
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .nightSky1
        addSubview(menuCV)
        menuCV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        menuCV.delegate = self
        menuCV.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.selectCell()
        }
    }
    private func selectCell() {
        menuCV.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
    }
}

extension ActivityTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tabMenus[indexPath.row].tabTitle.width(withConstraintedHeight: 24,
                                                                 font: .systemFont(ofSize: 18, weight: .semibold))
        return CGSize(width: 24 + buttonWidth, height: 44)
    }
}

extension ActivityTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TabMenuCVCell else {
            return UICollectionViewCell()
        }
        cell.menuLabel.text = tabMenus[indexPath.row].tabTitle
        cell.isSelected = indexPath.row == 0
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? TabMenuCVCell {
//            cell.showIcon()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? TabMenuCVCell {
//            cell.hideIcon()
//        }
//    }
}

class TabMenuCVCell: UICollectionViewCell {
    let menuLabel = MoyangLabel().then {
        $0.font = .headline
        $0.textColor = .sheep4
    }
    let selectBar = UIView().then {
        $0.backgroundColor = .sheep2
        $0.isHidden = true
    }
    let newImageView = UIView().then {
        $0.backgroundColor = .appleRed1
        $0.layer.cornerRadius = 3
        $0.isHidden = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                showIcon()
            } else {
                hideIcon()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .nightSky1
        setupMenuLabel()
        setupSelectBar()
        setupNewImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMenuLabel() {
        contentView.addSubview(menuLabel)
        menuLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    private func setupSelectBar() {
        contentView.addSubview(selectBar)
        selectBar.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(3)
            $0.centerX.equalTo(menuLabel)
        }
    }
    private func setupNewImageView() {
        contentView.addSubview(newImageView)
        newImageView.snp.makeConstraints {
            $0.top.equalTo(menuLabel).offset(-1)
            $0.left.equalTo(menuLabel.snp.right).offset(-1)
            $0.size.equalTo(6)
        }
    }
    
    func showIcon() {
        selectBar.isHidden = false
        let barWidth = menuLabel.text?.width(withConstraintedHeight: 24,
                                             font: .headline) ?? 36
        selectBar.snp.updateConstraints {
            $0.width.equalTo(barWidth + 4)
        }
        menuLabel.textColor = .sheep2
    }
    
    func hideIcon() {
        selectBar.isHidden = true
        menuLabel.textColor = .sheep4
    }
}
