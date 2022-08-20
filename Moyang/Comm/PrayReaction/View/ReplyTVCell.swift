//
//  ReplyTVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/08.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class ReplyTVCell: UITableViewCell {
    typealias VM = PrayReplyDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    weak var vm: VM?
    var index: Int?
    private var isBinded = false
    
    // MARK: - UI
    let bgView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = .sheep1
    }
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .sheep5
    }
    let contentTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
        $0.isEditable = false
    }
    let editButton = MoyangButton(.none).then {
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        $0.setTitleColor(.nightSky2, for: .normal)
    }
    let saveButton = MoyangButton(.none).then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        $0.setTitleColor(.ydGreen1, for: .normal)
        $0.isHidden = true
    }
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
        $0.clipsToBounds = true
        $0.barTintColor = .sheep3
    }
    let deleteButton = MoyangButton(.none).then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
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
        backgroundColor = .sheep2
        setupBgView()
        setupNameLabel()
        setupDateLabel()
        setupContentTextView()
        setupDeleteButton()
        setupEditButton()
        setupSaveButton()
    }
    private func setupBgView() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    private func setupNameLabel() {
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupDateLabel() {
        bgView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.left.equalToSuperview().inset(12)
        }
    }
    private func setupContentTextView() {
        bgView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(120)
            $0.bottom.equalToSuperview().inset(12)
        }
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: false)
        contentTextView.inputAccessoryView = toolBar
    }
    private func setupDeleteButton() {
        bgView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.right.equalToSuperview().inset(12)
        }
    }
    private func setupSaveButton() {
        bgView.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.right.equalTo(deleteButton.snp.left).offset(-12)
        }
    }
    
    private func setupEditButton() {
        bgView.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.right.equalTo(deleteButton.snp.left).offset(-12)
        }
        editButton.addTarget(self, action: #selector(toggleIsEditable(_:)), for: .touchUpInside)
    }
    func setupData(item: VM.ReplyItem) {
        guard let myInfo = UserData.shared.userInfo else { return }
        editButton.isHidden = myInfo.id != item.memberID
        deleteButton.isHidden = myInfo.id != item.memberID
        nameLabel.text = item.name
        dateLabel.text = item.date.isoToDateString("yyyy년 M월 d일")
        contentTextView.text = item.reply
    }
    
    @objc func toggleIsEditable(_ sender: UIButton ) {
        contentTextView.isEditable.toggle()
        editButton.setTitle(contentTextView.isEditable ? "취소" : "수정", for: .normal)
        if contentTextView.isEditable {
            contentTextView.inputAccessoryView = toolBar
            contentTextView.becomeFirstResponder()
            saveButton.isHidden = false
            editButton.snp.updateConstraints {
                $0.right.equalTo(deleteButton.snp.left).offset(-52)
            }
        } else {
            contentTextView.inputAccessoryView = nil
            saveButton.isHidden = true
            editButton.snp.updateConstraints {
                $0.right.equalTo(deleteButton.snp.left).offset(-12)
            }
        }
    }
    
    @objc func didTapDoneButton() {
        self.endEditing(true)
    }
    func bind() {
//        if let vm = vm {
//            if isBinded { return }
//            isBinded = true
//        }
    }
}
