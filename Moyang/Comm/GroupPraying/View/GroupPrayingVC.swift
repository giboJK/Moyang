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
import AVFoundation
import MarqueeLabel

class GroupPrayingVC: UIViewController, VCType {
    typealias VM = GroupPrayingVM
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayingVCDelegate?
    
    var player: AVAudioPlayer?
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.backButton.isHidden = true
        $0.closeButton.tintColor = .sheep2
        $0.titleLabel.isHidden = true
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel()
    let prevButton = UIButton()
    let nextButton = UIButton()
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
    let togglePlayingButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
    }
    let amenButton = MoyangButton(.primary).then {
        $0.setTitle("예수님의 이름으로 기도드립니다.", for: .normal)
    }
    
    var songURL: URL?
    
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
        stopSong()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        view.setGradient(color1: .nightSky3, color2: .nightSky2)
        setupNavBar()
        setupSongNameLabel()
        setupTogglePlayingButton()
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
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(200)
        }
    }
    private func setupSongNameLabel() {
        view.addSubview(songNameLabelBgView)
        songNameLabelBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(108)
            $0.bottom.equalToSuperview().inset(140)
        }

        songNameLabelBgView.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
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
    
    // music
    func playSong() {
        guard let songURL = songURL else {
            Log.e("songURL nil")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: songURL)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            player.numberOfLoops = -1
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch let error as NSError {
            Log.e(error.description)
        }
    }
    
    func stopSong() {
        player?.stop()
        player = nil
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
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(togglePlaySong: togglePlayingButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
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
        
        output.isPlaying
            .drive(onNext: { [weak self] isPlaying in
                if isPlaying {
                    self?.playSong()
                } else {
                    self?.stopSong()
                }
            }).disposed(by: disposeBag)
        
        output.songURL
            .drive(onNext: { [weak self] url in
                self?.songURL = url
            }).disposed(by: disposeBag)
        
    }
}

protocol GroupPrayingVCDelegate: AnyObject {
    
}
