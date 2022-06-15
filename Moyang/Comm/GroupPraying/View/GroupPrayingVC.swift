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
    let amenButton = MoyangButton(.primary).then {
        $0.setTitle("예수님의 이름으로 기도드립니다.", for: .normal)
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        view.setGradient(color1: .nightSky3, color2: .nightSky2)
        setupNavBar()
        setupSongNameLabel()
        setupTogglePlayingButton()
        setupTitleLabel()
        setupPrevButton()
        setupNextButton()
        setupPrayTableView()
        setupAmenButton()
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
            $0.top.equalTo(navBar.snp.bottom).offset(20)
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
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(180)
        }
    }
    private func setupSongNameLabel() {
        view.addSubview(songNameLabelBgView)
        songNameLabelBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(96)
            $0.bottom.equalToSuperview().inset(140)
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
    private func setupTogglePlayingButton() {
        view.addSubview(togglePlayingButton)
        togglePlayingButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(songNameLabel.snp.bottom).offset(16)
            $0.size.equalTo(24)
        }
    }
    private func setupAmenButton() {
        view.addSubview(amenButton)
        amenButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(UIApplication.bottomInset + 8)
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
                self?.dismiss(animated: true)
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
                             togglePlaySong: togglePlayingButton.rx.tap.asDriver())
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
                .items(cellIdentifier: "cell", cellType: GroupPrayingTableViewCell.self)) { (_, item, cell) in
                    cell.prayLabel.text = item.pray
                    cell.prayLabel.lineBreakMode = .byTruncatingTail
                    cell.tags = item.tags
                    cell.tagCollectionView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        cell.updateTagCollectionViewHeight()
                    }
                    cell.noTagLabel.isHidden = !item.tags.isEmpty
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                }.disposed(by: disposeBag)
        
        output.isNextEnabled
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isPrevEnabled
            .drive(prevButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

protocol GroupPrayingVCDelegate: AnyObject {
    
}
