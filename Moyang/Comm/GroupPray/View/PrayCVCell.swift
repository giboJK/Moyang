//
//  PrayCVCell.swift
//  Moyang
//
//  Created by kibo on 2022/08/04.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class PrayCVCell: UICollectionViewCell {
    typealias VM = GroupPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    let bgView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = .sheep2
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .nightSky2
    }
    let latestPrayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
        $0.numberOfLines = 0
    }
    // TODO: - 자물쇠 아이콘으로 나만 보이도록 수정
    let isSecretImageView = UILabel().then {
        $0.text = "비공개 기도입니다"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .sheep5
        $0.isHidden = true
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
        $0.register(PrayTagCVCell.self, forCellWithReuseIdentifier: "cell")
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
    var userID: String = ""
    var row: Int?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBgView()
        setupDateLabel()
        setupIsSecretImageView()
        setupLatestPrayLabel()
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
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    private func setupDateLabel() {
        bgView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    private func setupLatestPrayLabel() {
        bgView.addSubview(latestPrayLabel)
        latestPrayLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    private func setupIsSecretImageView() {
        bgView.addSubview(isSecretImageView)
        isSecretImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.right.equalToSuperview().inset(12)
            $0.height.equalTo(20)
        }
    }
    private func setupPrayCountLabel() {
        bgView.addSubview(prayCountLabel)
        prayCountLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
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
    
    private func bind() {
        self.rx.longPressGesture().when(.began)
            .subscribe(onNext: { [weak self] _ in
                guard let row = self?.row else { return }
                let indexDict = ["index": row]
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
                guard let self = self, let row = self.row else { return }
                let indexDict = ["index": row]
                NotificationCenter.default.post(name: NSNotification.Name("GROUP_PRAY_REACTION_TAP"),
                                                object: nil,
                                                userInfo: indexDict)
            }).disposed(by: disposeBag)
        
        replyView.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let row = self.row else { return }
                let indexDict = ["index": row]
                NotificationCenter.default.post(name: NSNotification.Name("GROUP_PRAY_REPLY_TAP"),
                                                object: nil,
                                                userInfo: indexDict)
            }).disposed(by: disposeBag)
    }
    
    func setupData(item: GroupIndividualPray) {
        updateLatestPrayLabelHeight()
        dateLabel.text = item.latestDate.isoToDateString() ?? ""
        latestPrayLabel.text = item.pray
        tags = item.tags
        tagCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.updateTagCollectionViewHeight()
        }
        noTagLabel.isHidden = !item.tags.isEmpty
        isSecretImageView.isHidden = !item.isSecret
        setupReactionAndReplyView(reactions: item.reactions, replys: item.replys)
        
        prayCountLabel.isHidden = item.changes.isEmpty
        firstPrayDateLabel.isHidden = item.changes.isEmpty
        firstPrayLabel.isHidden = item.changes.isEmpty
        firstPrayDivider.isHidden = item.changes.isEmpty
        if !item.changes.isEmpty {
            prayCountLabel.text = "총 \(item.changes.count + 1)개의 기도가 있습니다."
            firstPrayDateLabel.text = "처음 등록일: " + item.createDate.isoToDateString()!
            firstPrayLabel.text = item.pray
            firstPrayLabel.lineBreakMode = .byTruncatingTail
            latestPrayLabel.text = item.changes.first!.content
            dateLabel.text = "최근 기록일: " + item.changes.first!.date

            dateLabel.snp.remakeConstraints {
                $0.top.equalTo(firstPrayDivider.snp.bottom).offset(8)
                $0.left.equalToSuperview().inset(12)
                $0.height.equalTo(20)
            }
        } else {
            dateLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(8)
                $0.left.right.equalToSuperview().inset(12)
            }
        }
    }
}

extension PrayCVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = tags[indexPath.row].width(withConstraintedHeight: 16,
                                                    font: .systemFont(ofSize: 14, weight: .regular))
        return CGSize(width: 20 + buttonWidth, height: 28)
    }
}

extension PrayCVCell: UICollectionViewDataSource {
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
