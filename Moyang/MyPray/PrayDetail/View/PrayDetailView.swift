//
//  PrayDetailView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/09.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class PrayDetailView: UIView, UITextFieldDelegate {
    typealias VM = MyPrayDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    let groupNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep2
    }
    let prayTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let reactionView = UIStackView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 14
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.isHidden = true
    }
    let replyView = UIView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 14
    }
    let replyImageView = UIImageView(image: Asset.Images.Pray.comment.image.withTintColor(.nightSky1))
    let replyCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .nightSky3
    }
    
    // MARK: - Property
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    deinit { Log.i(self) }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupGroupNameLabel()
        setupDateLabel()
        setupPrayTextField()
        setupReactionView()
        setupReplyView()
    }
    private func setupGroupNameLabel() {
        addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(80)
        }
    }
    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupPrayTextField() {
        addSubview(prayTextView)
        prayTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(300)
        }
    }
    
    func setupReactionView() {
        addSubview(reactionView)
        reactionView.snp.makeConstraints {
            $0.top.equalTo(prayTextView.snp.bottom).offset(8)
            $0.right.equalTo(prayTextView)
            $0.width.equalTo(0)
            $0.height.equalTo(32)
        }
    }
    
    private func setupReplyView() {
        addSubview(replyView)
        replyView.snp.makeConstraints {
            $0.top.equalTo(prayTextView.snp.bottom).offset(8)
            $0.right.equalTo(prayTextView)
            $0.height.equalTo(32)
        }
        replyView.addSubview(replyImageView)
        replyView.addSubview(replyCountLabel)
        replyImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(8)
            $0.size.equalTo(20)
        }
        replyCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(replyImageView.snp.right).offset(4)
            $0.right.equalToSuperview().inset(8)
        }
        replyView.isHidden = true
    }
    func setupReplyView(replys: [PrayReply]) {
        if replys.isEmpty { replyView.isHidden = true; return }
        replyView.isHidden = false
        replyCountLabel.text = "\(replys.count)"
        reactionView.snp.updateConstraints {
            $0.right.equalTo(prayTextView).offset(-replyView.frame.width-16)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    @objc func didTapDoneButton() {
        endEditing(true)
    }
    @objc func didTapCancelButton() {
        endEditing(true)
    }
    func setupReactionView(reactions: [PrayReaction]) {
        for view in reactionView.arrangedSubviews {
            reactionView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        var love = 0
        var joy = 0
        var sad = 0
        var pray = 0
        reactions.forEach { reaction in
            if let type = PrayReactionType(rawValue: reaction.type) {
                switch type {
                case .love:
                    love += 1
                case .joyful:
                    joy += 1
                case .sad:
                    sad += 1
                case .prayWithYou:
                    pray += 1
                }
            }
        }
        if love > 0 {
            let view = PrayReactionView(type: .love, count: love)
            reactionView.addArrangedSubview(view)
        }
        
        if joy > 0 {
            let view = PrayReactionView(type: .joyful, count: joy)
            reactionView.addArrangedSubview(view)
        }
        if sad > 0 {
            let view = PrayReactionView(type: .sad, count: sad)
            reactionView.addArrangedSubview(view)
        }
        if pray > 0 {
            let view = PrayReactionView(type: .prayWithYou, count: pray)
            reactionView.addArrangedSubview(view)
        }
        reactionView.snp.updateConstraints {
            $0.width.equalTo(reactionView.subviews.count * 48)
        }
        reactionView.isHidden = false
    }
    private func setupToolbar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.barTintColor = .sheep3
        }
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: false)
        prayTextView.inputAccessoryView = toolBar
    }
    
    func bind() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setTitle: prayTextView.rx.text.asDriver())
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(groupNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
