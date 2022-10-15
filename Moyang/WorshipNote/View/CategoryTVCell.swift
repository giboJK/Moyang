//
//  CategoryTVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/16.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class CategoryTVCell: UITableViewCell {
    typealias VM = WorshipNoteVM
    var disposeBag: DisposeBag = DisposeBag()
    weak var vm: VM?
    var isBinded = false
    
    // MARK: - UI
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .sheep2
        $0.isUserInteractionEnabled = false
    }
    let divider = UIView().then {
        $0.backgroundColor = .sheep3.withAlphaComponent(0.7)
    }
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .nightSky1
        selectedBackgroundView = backgroundView
        
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
        contentView.backgroundColor = .nightSky1
        setupNameLabel()
        setupDivider()
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    
    private func setupDivider() {
        contentView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview()
        }
    }
    
    func bind() {
        if let vm = vm {
            if isBinded { return }
        }
    }
}
