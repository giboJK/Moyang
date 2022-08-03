//
//  GroupPrayTableViewCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class GroupPrayTableViewCell: UITableViewCell {
    var disposeBag: DisposeBag = DisposeBag()
    // MARK: - UI
    let bgView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = .sheep2
    }
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .sheep5
    }
    let isSecretLabel = UILabel().then {
        $0.text = "비공개 기도입니다"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .sheep5
        $0.isHidden = true
    }
    let latestPrayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
        $0.numberOfLines = 0
    }
    let prayCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
        $0.isHidden = true
    }
    let firstPrayDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .nightSky4
        $0.isHidden = true
    }
    let firstPrayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .nightSky4
        $0.isHidden = true
    }
    let firstPrayDivider = UIView().then {
        $0.backgroundColor = .sheep3
        $0.isHidden = true
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
        $0.register(PrayTagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    let noTagLabel = UILabel().then {
        $0.text = "#태그"
        $0.textColor = .nightSky3
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    let reactionView = UIStackView().then {
        $0.backgroundColor = .sheep2
        $0.layer.cornerRadius = 14
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    let replyView = UIView().then {
        $0.backgroundColor = .sheep2
        $0.layer.cornerRadius = 14
    }
    let replyImageView = UIImageView(image: Asset.Images.Pray.comment.image.withTintColor(.nightSky1))
    let replyCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .nightSky3
    }
    let changeView = UIView().then {
        $0.backgroundColor = .sheep2
        $0.layer.cornerRadius = 14
    }
    let changeImageView = UIImageView(image: Asset.Images.Pray.changeRecord.image.withTintColor(.nightSky1))
    let changeCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .nightSky3
    }
    
    var tags = [String]()
    var index: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .sheep1
        selectedBackgroundView = backgroundView
        
        setupUI()
        
        self.rx.longPressGesture().when(.began)
            .subscribe(onNext: { [weak self] _ in
                guard let index = self?.index else { return }
                let indexDict = ["index": index]
                NotificationCenter.default.post(name: NSNotification.Name("GROUP_PRAY_REACTIONVIEW_MOVE"),
                                                object: nil,
                                                userInfo: indexDict)
            }).disposed(by: disposeBag)
        
        self.rx.longPressGesture().when(.began)
            .delay(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                NotificationCenter.default.post(name: NSNotification.Name("GROUP_PRAY_REACTIONVIEW_SHOW"),
                                                object: nil,
                                                userInfo: nil)
            }).disposed(by: disposeBag)
        
        reactionView.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let index = self.index else { return }
                let indexDict = ["index": index]
                NotificationCenter.default.post(name: NSNotification.Name("GROUP_PRAY_REACTION_TAP"),
                                                object: nil,
                                                userInfo: indexDict)
            }).disposed(by: disposeBag)
        
        replyView.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let index = self.index else { return }
                let indexDict = ["index": index]
                NotificationCenter.default.post(name: NSNotification.Name("GROUP_PRAY_REPLY_TAP"),
                                                object: nil,
                                                userInfo: indexDict)
            }).disposed(by: disposeBag)
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
        setupBgView()
        setupNameLabel()
        setupDateLabel()
        setupIsSecretLabel()
        setupPrayCountLabel()
        setupFirstPrayDateLabel()
        setupFirstPrayLabel()
        setupFirstPrayDivider()
        setupLatestPrayLabel()
        setupTagDivider()
        setupTagCollectionView()
        setupNoTagLabel()
        setupReplyView()
    }
    
    private func setupBgView() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    private func setupNameLabel() {
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(20)
        }
    }
    private func setupDateLabel() {
        bgView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.left.equalToSuperview().inset(12)
            $0.height.equalTo(20)
        }
    }
    private func setupIsSecretLabel() {
        bgView.addSubview(isSecretLabel)
        isSecretLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.right.equalToSuperview().inset(12)
            $0.height.equalTo(20)
        }
    }
    
    private func setupLatestPrayLabel() {
        bgView.addSubview(latestPrayLabel)
        latestPrayLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupPrayCountLabel() {
        bgView.addSubview(prayCountLabel)
        prayCountLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupFirstPrayDateLabel() {
        bgView.addSubview(firstPrayDateLabel)
        firstPrayDateLabel.snp.makeConstraints {
            $0.top.equalTo(prayCountLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupFirstPrayLabel() {
        bgView.addSubview(firstPrayLabel)
        firstPrayLabel.snp.makeConstraints {
            $0.top.equalTo(firstPrayDateLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupFirstPrayDivider() {
        bgView.addSubview(firstPrayDivider)
        firstPrayDivider.snp.makeConstraints {
            $0.top.equalTo(firstPrayLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    private func setupTagDivider() {
        bgView.addSubview(tagDivider)
        tagDivider.snp.makeConstraints {
            $0.top.equalTo(latestPrayLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func setupTagCollectionView() {
        bgView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagDivider.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(28)
        }
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    private func setupNoTagLabel() {
        bgView.addSubview(noTagLabel)
        noTagLabel.snp.makeConstraints {
            $0.top.equalTo(tagDivider.snp.bottom).offset(4)
            $0.height.equalTo(28)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupReplyView() {
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
        }
    }
    
    func updateLatestPrayLabelHeight() {
        latestPrayLabel.snp.remakeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(12)
            $0.height.lessThanOrEqualTo(116)
        }
        latestPrayLabel.lineBreakMode = .byTruncatingTail
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
    private func setupReactionView(reactions: [PrayReaction]) {
        if reactions.isEmpty { return }
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
        if reactionView.superview == nil {
            contentView.addSubview(reactionView)
        }
        reactionView.snp.remakeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            if replyView.superview == nil {
                $0.right.equalToSuperview()
            } else {
                $0.right.equalTo(replyView.snp.left).offset(-8)
            }
            $0.width.equalTo(reactionView.subviews.count * 48)
            $0.height.equalTo(28)
        }
    }
    private func setupReplyView(replys: [PrayReply]) {
        if replys.isEmpty { return }
        if replyView.superview == nil {
            contentView.addSubview(replyView)
        }
        replyCountLabel.text = "\(replys.count)"
        replyView.snp.remakeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.right.equalToSuperview()
            $0.height.equalTo(28)
            $0.width.equalTo(48)
        }
    }
    func setupReactionAndReplyView(reactions: [PrayReaction], replys: [PrayReply]) {
        for view in reactionView.subviews {
            view.removeFromSuperview()
        }
        if reactions.isEmpty {
            reactionView.removeFromSuperview()
        }
        if replys.isEmpty {
            replyView.removeFromSuperview()
        }
        if replys.isEmpty && reactions.isEmpty {
            bgView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(12)
            }
            return
        }
        bgView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(40)
        }
        self.setupReplyView(replys: replys)
        self.setupReactionView(reactions: reactions)
    }
    func setupData(item: GroupPrayVM.GroupPrayItem, isPreview: Bool = false) {
        if isPreview {
            updateLatestPrayLabelHeight()
        }
        nameLabel.text = item.name
        dateLabel.text = item.latestDate
        latestPrayLabel.text = item.pray
        tags = item.tags
        tagCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.updateTagCollectionViewHeight()
        }
        noTagLabel.isHidden = !item.tags.isEmpty
        isSecretLabel.isHidden = !item.isSecret
//        setupReactionAndReplyView(reactions: item.reactions, replys: item.replys)
        
//        prayCountLabel.isHidden = item.changes.isEmpty
//        firstPrayDateLabel.isHidden = item.changes.isEmpty
//        firstPrayLabel.isHidden = item.changes.isEmpty
//        firstPrayDivider.isHidden = item.changes.isEmpty
//        if !item.changes.isEmpty {
//            prayCountLabel.text = "총 \(item.changes.count + 1)개의 기도가 있습니다."
//            firstPrayDateLabel.text = "처음 등록일: " + item.registeredDate
//            firstPrayLabel.text = item.pray
//            firstPrayLabel.lineBreakMode = .byTruncatingTail
//            latestPrayLabel.text = item.changes.first!.reply
//            dateLabel.text = "최근 기록일: " + item.changes.first!.date
//            
//            dateLabel.snp.remakeConstraints {
//                $0.top.equalTo(firstPrayDivider.snp.bottom).offset(8)
//                $0.left.equalToSuperview().inset(12)
//                $0.height.equalTo(20)
//            }
//        } else {
//            dateLabel.snp.remakeConstraints {
//                $0.top.equalTo(nameLabel.snp.bottom).offset(2)
//                $0.left.equalToSuperview().inset(12)
//                $0.height.equalTo(20)
//            }
//        }
    }
}

extension GroupPrayTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tags[indexPath.row].width(withConstraintedHeight: 16,
                                                    font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + buttonWidth, height: 28)
    }
}

extension GroupPrayTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PrayTagCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tags[indexPath.row]
        
        return cell
    }
}
