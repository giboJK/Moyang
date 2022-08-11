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
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.backButton.isHidden = true
        $0.closeButton.tintColor = .sheep2
        $0.titleLabel.isHidden = true
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
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
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupPrayingTableViewCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 220
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let songNameLabelBgView = UIView().then {
        $0.backgroundColor = .sheep2
        $0.layer.cornerRadius = 8
        $0.alpha = 0.6
    }
    let songNameLabel = MarqueeLabel.init(frame: .zero, duration: 10.0, fadeLength: 0.0).then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .nightSky1
    }
    lazy var musicNoteImageView = UIImageView().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold, scale: .large)
        $0.image = UIImage(systemName: "music.note", withConfiguration: config)
        $0.tintColor = .nightSky1
    }
    let togglePlayingButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
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
        $0.desc = "기도를 마치시겠어요? 하단의 버튼을 통해 예수님의 이름으로 아멘해보세요."
        $0.firstButton.setTitle("나가기", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
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
        vm?.stopSong()
        NotificationCenter.default.post(name: NSNotification.Name("PRAYING_STOP"), object: nil, userInfo: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        view.setGradient(startColor: .nightSky3, endColor: .nightSky2)
        setupNavBar()
        setupTitleLabel()
        setupPrevButton()
        setupNextButton()
        
        setupAmenButton()
        setupPrayingTimeLabel()
        setupTogglePlayingButton()
        setupSongNameLabel()
        
        setupPrayTableView()
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
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navBar.snp.bottom).offset(12)
        }
    }
    private func setupPrevButton() {
        view.addSubview(prevButton)
        prevButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(24)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(24)
            $0.right.equalToSuperview().inset(24)
        }
    }
    private func setupAmenButton() {
        view.addSubview(amenButton)
        amenButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(28)
            $0.bottom.equalTo(view.safeAreaInsets).inset(28)
        }
    }
    private func setupPrayingTimeLabel() {
        view.addSubview(prayingTimeLabel)
        prayingTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(amenButton.snp.top).offset(-12)
        }
    }
    private func setupTogglePlayingButton() {
        view.addSubview(togglePlayingButton)
        togglePlayingButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(prayingTimeLabel.snp.top).offset(-8)
            $0.size.equalTo(24)
        }
    }
    private func setupSongNameLabel() {
        view.addSubview(songNameLabelBgView)
        songNameLabelBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(96)
            $0.bottom.equalTo(togglePlayingButton.snp.top).offset(-4)
        }

        songNameLabelBgView.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(36)
        }
        
        songNameLabelBgView.addSubview(musicNoteImageView)
        musicNoteImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalTo(songNameLabel)
            $0.left.equalToSuperview().inset(8)
        }
    }
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(songNameLabelBgView.snp.top).offset(-12)
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        navBar.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.closeConfirmPopup)
            }).disposed(by: disposeBag)
        
        closeConfirmPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.closePopup {
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
        
        closeConfirmPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        prayTableView.rx.contentOffset.asDriver()
            .throttle(.milliseconds(300))
            .drive(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                let offset = self.prayTableView.contentOffset.y
                let maxOffset = self.prayTableView.contentSize.height - self.prayTableView.frame.size.height
                if maxOffset - offset <= 0 {
                    self.vm?.fetchMorePrayList()
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(prevMemberPray: prevButton.rx.tap.asDriver(),
                             nextMemberPray: nextButton.rx.tap.asDriver(),
                             togglePlaySong: togglePlayingButton.rx.tap.asDriver(),
                             amen: amenButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.selectedMemberName
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
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupPrayingTableViewCell.self)) { (index, item, cell) in
                    cell.prayLabel.text = item.pray
                    cell.prayLabel.lineBreakMode = .byTruncatingTail
//                    cell.tags = item.tags
                    cell.tagCollectionView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        cell.updateTagCollectionViewHeight()
                    }
//                    cell.noTagLabel.isHidden = !item.tags.isEmpty
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    
                    cell.vm = vm
                    cell.index = index
                    cell.bind()
                }.disposed(by: disposeBag)
        
        output.isNextEnabled
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isPrevEnabled
            .drive(prevButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
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
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

protocol GroupPrayingVCDelegate: AnyObject {
    
}
