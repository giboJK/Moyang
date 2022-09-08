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
    typealias VM = GroupPrayDetailVM
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
    let tagTextField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep3
        $0.layer.cornerRadius = 8
        $0.attributedPlaceholder = NSAttributedString(string: "#태그 선택",
                                                      attributes: [.foregroundColor: UIColor.sheep4])
        $0.textColor = .nightSky1
        $0.returnKeyType = .done
    }
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.register(NewPrayTagCVCell.self, forCellWithReuseIdentifier: "cell")
    }
    let isSecretLabel = UILabel().then {
        $0.text = "나만 보기"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep2
    }
    let isSecretCheckBox = CheckBox()
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
    private var tagList = [String]()
    var isMyPray = false
    
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
        setupTagTextField()
        setupTagCollectionView()
        setupIsSecretLabel()
        setupIsSecretCheckBox()
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
            $0.height.equalTo(220)
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
    private func setupTagTextField() {
        addSubview(tagTextField)
        tagTextField.snp.makeConstraints {
            $0.top.equalTo(prayTextView.snp.bottom).offset(48)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        tagTextField.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.barTintColor = .sheep3
        }
        let cancelButton = UIBarButtonItem(title: "취소",
                                           style: .plain,
                                         target: self,
                                         action: #selector(didTapCancelButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, space], animated: false)
        tagTextField.inputAccessoryView = toolBar
    }
    private func setupTagCollectionView() {
        addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(16)
            if isMyPray {
                $0.right.equalToSuperview().inset(16)
            } else {
                $0.right.equalTo(reactionView.snp.left).offset(-16)
            }
            $0.height.equalTo(32)
        }
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }
    
    private func setupIsSecretLabel() {
        addSubview(isSecretLabel)
        isSecretLabel.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
        }
    }
    private func setupIsSecretCheckBox() {
        addSubview(isSecretCheckBox)
        isSecretCheckBox.snp.makeConstraints {
            $0.centerY.equalTo(isSecretLabel)
            $0.left.equalTo(isSecretLabel.snp.right).offset(4)
            $0.size.equalTo(18)
            $0.bottom.equalToSuperview()
        }
    }
    private func increaseTagCollectionViewHeight(count: Int) {
        let currentHeight = tagCollectionView.bounds.height
        tagCollectionView.snp.updateConstraints {
            $0.height.equalTo(currentHeight + 8 + 32)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
            if self.tagCollectionView.visibleCells.count < count {
                self.increaseTagCollectionViewHeight(count: count)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagTextField.resignFirstResponder()
        return true
    }
    @objc func didTapDoneButton() {
        endEditing(true)
    }
    @objc func didTapCancelButton() {
        tagTextField.text?.removeAll()
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
        let input = VM.Input(setPray: prayTextView.rx.text.asDriver(),
                             setTag: tagTextField.rx.text.asDriver(),
                             addTag: tagTextField.rx.controlEvent(.editingDidEnd).asDriver(),
                             toggleIsSecret: isSecretCheckBox.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.isMyPray
            .drive(onNext: { [weak self] isMyPray in
                guard let self = self else { return }
                self.tagTextField.isHidden = !isMyPray
                self.isSecretLabel.isHidden = !isMyPray
                self.isSecretCheckBox.isHidden = !isMyPray
                self.prayTextView.isEditable = isMyPray
                self.prayTextView.textDragInteraction?.isEnabled = !isMyPray
                if isMyPray {
                    self.setupToolbar()
                }
                self.tagCollectionView.snp.remakeConstraints {
                    $0.left.equalToSuperview().inset(16)
                    $0.height.equalTo(32)
                    if isMyPray {
                        $0.right.equalToSuperview().inset(16)
                        $0.top.equalTo(self.tagTextField.snp.bottom).offset(12)
                    } else {
                        $0.right.equalTo(self.reactionView.snp.left).offset(-16)
                        $0.top.equalTo(self.prayTextView.snp.bottom).offset(12)
                    }
                }
            }).disposed(by: disposeBag)
        
        output.groupName
            .drive(groupNameLabel.rx.text)
            .disposed(by: disposeBag)
        output.date
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        output.pray
            .distinctUntilChanged()
            .drive(prayTextView.rx.text)
            .disposed(by: disposeBag)
        output.newTag
            .drive(tagTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.tagList
            .map { $0.count >= 5 }
            .drive(onNext: { [weak self] isFullTag in
                self?.tagTextField.backgroundColor = isFullTag ? .sheep3 : .sheep1
                self?.tagTextField.isEnabled = !isFullTag
            }).disposed(by: disposeBag)
        
        output.tagList
            .drive(onNext: { [weak self] list in
                self?.tagList = list
                self?.tagCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        output.tagList
            .delay(.milliseconds(100))
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                if self.tagCollectionView.visibleCells.count < list.count {
                    self.increaseTagCollectionViewHeight(count: list.count)
                } else {
                    if !self.tagCollectionView.visibleCells.isEmpty {
                        var maxY: CGFloat = 0
                        self.tagCollectionView.visibleCells.forEach { cell in
                            maxY = max(cell.frame.maxY, maxY)
                        }
                        let currentHeight = self.tagCollectionView.bounds.height
                        if currentHeight - maxY > 8 {
                            self.tagCollectionView.snp.updateConstraints {
                                $0.height.equalTo(currentHeight - 8 - 32)
                            }
                        }
                    } else {
                        self.tagCollectionView.snp.updateConstraints {
                            $0.height.equalTo(0)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        output.isSecret
            .drive(isSecretCheckBox.rx.isChecked)
            .disposed(by: disposeBag)
        
        output.reactions
            .drive(onNext: { [weak self] reactions in
                if reactions.isEmpty { self?.reactionView.isHidden = true; return }
                self?.setupReactionView(reactions: reactions)
            }).disposed(by: disposeBag)
        
        output.isMyPray
            .drive(onNext: { [weak self] isMyPray in
                self?.isMyPray = isMyPray
            }).disposed(by: disposeBag)
        
        output.replys
            .delay(.milliseconds(100))
            .drive(onNext: { [weak self] replys in
                self?.setupReplyView(replys: replys)
            }).disposed(by: disposeBag)
    }
}

extension PrayDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tagList[indexPath.row].width(withConstraintedHeight: 16,
                                                       font: .systemFont(ofSize: 14, weight: .regular))
        if isMyPray {
            return CGSize(width: 20 + 24 + buttonWidth, height: 32)
        }
        return CGSize(width: 20 + buttonWidth, height: 32)
    }
}

extension PrayDetailView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewPrayTagCVCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tagList[indexPath.row]
        cell.detailVM = vm
        cell.indexPath = indexPath
        cell.bind()
        cell.deleteButton.isHidden = !isMyPray
        
        return cell
    }
}
