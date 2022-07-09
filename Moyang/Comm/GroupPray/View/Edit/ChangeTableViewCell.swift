//
//  ChangeTableViewCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/09.
//
import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class ChangeTableViewCell: UITableViewCell {
    typealias VM = GroupPrayEditVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var index: Int?
    private var isBinded = false
    
    // MARK: - UI
    let bgView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = .sheep1
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .sheep5
    }
    let changeTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
        $0.isEditable = false
    }
    let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setTitleColor(.nightSky3, for: .normal)
    }
    let deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setTitleColor(.appleRed1, for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
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
    
    private func setupUI() {
        contentView.backgroundColor = .sheep2
        setupBgView()
        setupDateLabel()
        setupChangeTextField()
        setupDeleteButton()
        setupEditButton()
    }
    private func setupBgView() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    private func setupDateLabel() {
        bgView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(12)
        }
    }
    private func setupChangeTextField() {
        bgView.addSubview(changeTextView)
        changeTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(120)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    private func setupDeleteButton() {
        bgView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.right.equalToSuperview().inset(12)
        }
    }
    private func setupEditButton() {
        bgView.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.right.equalTo(deleteButton.snp.left).offset(-12)
        }
    }
    
    func setupData(item: VM.PrayChangeItem) {
        dateLabel.text = item.date
        changeTextView.text = item.reply
    }
    
    func bind() {
        if let vm = vm {
            if isBinded { return }
            isBinded = true
        }
    }
}
