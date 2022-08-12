//
//  GroupPrayingVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import MarqueeLabel
import Toast_Swift

class GroupPrayingVC: UIViewController, VCType {
    typealias VM = GroupPrayingVM
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayingVCDelegate?
    var showSongController = false
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
        $0.backButton.tintColor = .sheep2
        $0.titleLabel.isHidden = true
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 21, weight: .semibold)
        $0.textColor = .sheep1
    }
    let prevButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep2
    }
    let nextButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "chevron.right", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep2
    }
    let prayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PrayingCVCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        return cv
    }()
    let myPrayButtonContainer = UIView()
    let answerButton = MoyangButton(.none).then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor.sheep2,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "대답을 주셨나요?",
            attributes: attributes
        )
        $0.setAttributedTitle(attributeString, for: .normal)
    }
    let middleLable = UILabel().then {
        $0.text = " 혹은 기도에 "
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep2.withAlphaComponent(0.9)
    }
    let changeButton = MoyangButton(.none).then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor.sheep2,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "변화가 있나요?",
            attributes: attributes
        )
        $0.setAttributedTitle(attributeString, for: .normal)
    }
    let prayPlusButton = MoyangButton(.none).then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor.sheep2,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "더하고 싶은 기도가 있나요?",
            attributes: attributes
        )
        $0.setAttributedTitle(attributeString, for: .normal)
    }
    
    let songController = UIView().then {
        $0.backgroundColor = .sheep2
        $0.layer.cornerRadius = 8
        $0.alpha = 0.6
    }
    let songNameLabel = MarqueeLabel.init(frame: .zero, duration: 10.0, fadeLength: 0.0).then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let musicNoteButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "music.note", withConfiguration: config), for: .normal)
        $0.tintColor = .nightSky1
    }
    let togglePlayingButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        $0.tintColor = .nightSky1
    }
    let prayingTimeLabel = UILabel().then {
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textAlignment = .center
    }
    let amenButton = MoyangButton(.primary).then {
        $0.setTitle("예수님의 이름으로 기도드립니다.", for: .normal)
    }
    let reactionPopupView = UIView()
    let closeConfirmPopup = MoyangPopupView(style: .twoButton).then {
        $0.desc = "기도를 마치시겠어요?\n예수님의 이름으로 기도드립니다."
        $0.firstButton.setTitle("아멘", for: .normal)
        $0.secondButton.setTitle("더 기도하기", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    override  func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MarqueeLabel.controllerViewDidAppear(self)
    }
    
    deinit {
        Log.i(self)
        vm?.finishPray()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        view.setGradient(startColor: .nightSky3, endColor: .nightSky2)
        setupNavBar()
        setupTitleLabel()
        setupSongController()
        setupPrayingTimeLabel()
        setupPrayCollectionView()
        setupAmenButton()
        setupMyPrayButtonContainer()
        setupPrayPlusButton()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(28)
            $0.right.equalToSuperview().inset(120)
            $0.top.equalTo(navBar.snp.bottom).offset(20)
        }
    }
    private func setupSongController() {
        view.addSubview(songController)
        songController.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.right.equalToSuperview().offset(140)
        }

        songController.addSubview(musicNoteButton)
        musicNoteButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.equalToSuperview().inset(4)
        }
        songController.addSubview(togglePlayingButton)
        togglePlayingButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.right.equalToSuperview().inset(8)
        }
        songController.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(musicNoteButton.snp.right).offset(4)
            $0.right.equalTo(togglePlayingButton.snp.left).offset(-4)
            $0.width.equalTo(104)
        }
        
    }
    private func setupPrayingTimeLabel() {
        view.addSubview(prayingTimeLabel)
        prayingTimeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(28)
            $0.bottom.equalTo(titleLabel)
        }
    }
    private func setupPrayCollectionView() {
        view.addSubview(prayCollectionView)
        prayCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(36)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(400)
        }
        prayCollectionView.delegate = self
    }
    
    private func setupAmenButton() {
        view.addSubview(amenButton)
        amenButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(28)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(48)
        }
    }
    private func setupMyPrayButtonContainer() {
        view.addSubview(myPrayButtonContainer)
        myPrayButtonContainer.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.centerX.equalToSuperview()
        }
        setupAnswerButton()
        setupMiddleLable()
        setupChangeButton()
    }
    private func setupAnswerButton() {
        myPrayButtonContainer.addSubview(answerButton)
        answerButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
    private func setupMiddleLable() {
        myPrayButtonContainer.addSubview(middleLable)
        middleLable.snp.makeConstraints {
            $0.left.equalTo(answerButton.snp.right)
            $0.centerY.equalToSuperview()
        }
    }
    private func setupChangeButton() {
        myPrayButtonContainer.addSubview(changeButton)
        changeButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.left.equalTo(middleLable.snp.right)
            $0.top.bottom.equalToSuperview()
        }
    }
    private func setupPrayPlusButton() {
        view.addSubview(prayPlusButton)
        prayPlusButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func toggleSongController() {
        if showSongController {
            songController.snp.updateConstraints {
                $0.right.equalToSuperview().inset(28)
            }
        } else {
            songController.snp.updateConstraints {
                $0.right.equalToSuperview().offset(140)
            }
        }
        showSongController.toggle()
        UIView.animate(withDuration: 1.5) {
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.closeConfirmPopup)
            }).disposed(by: disposeBag)
        
        closeConfirmPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        closeConfirmPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        musicNoteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.toggleSongController()
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(togglePlaySong: togglePlayingButton.rx.tap.asDriver(),
                             amen: amenButton.rx.tap.asDriver(),
                             amenPopup: closeConfirmPopup.firstButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.selectedMemberName
            .map { $0 + "의 기도"}
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.songName
            .drive(songNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isPlaying
            .map { isPlaying -> UIImage? in
                let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold, scale: .large)
                if !isPlaying {
                    return UIImage(systemName: "play.fill", withConfiguration: config)
                }
                return UIImage(systemName: "pause.fill", withConfiguration: config)
            }
            .drive(togglePlayingButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        output.prayList
            .drive(prayCollectionView.rx
                .items(cellIdentifier: "cell", cellType: PrayingCVCell.self)) { (_, item, cell) in
                    cell.dateLabel.text = item.latestDate.isoToDateString()
                    cell.prayTextView.text = item.pray
                    cell.tags = item.tags
                    cell.tagCollectionView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        cell.updateTagCollectionViewHeight()
                    }
                    cell.noTagLabel.isHidden = !item.tags.isEmpty
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                }.disposed(by: disposeBag)
        
        output.isMe
            .drive(onNext: { [weak self] isMe in
                self?.myPrayButtonContainer.isHidden = !isMe
                self?.prayPlusButton.isHidden = isMe
            }).disposed(by: disposeBag)
        
        output.prayingTimeStr
            .drive(prayingTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isAmenEnable
            .drive(amenButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.amenSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.view.makeToast("예수님의 이름으로 기도드립니다. 아멘.", duration: 3.0, position: .center)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension GroupPrayingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-58, height: 400)
    }
}

protocol GroupPrayingVCDelegate: AnyObject {
    
}
