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
    typealias VM = WorshipNoteVM
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
    let divider = UIView().then {
        $0.backgroundColor = .sheep3.withAlphaComponent(0.7)
    }
    
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
    }
    
    func bind() {
    }
}
