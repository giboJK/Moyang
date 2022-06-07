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

class GroupPrayingVC: UIViewController, VCType {
    typealias VM = GroupPrayingVM
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayingVCDelegate?

    var player: AVAudioPlayer?
    var songNmae: String?
    var fileExt: String?

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
    let togglePlayingButton = UIButton().then {
        $0.setTitle("시작", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
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
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    
    // music
    func playSound(name: String, fileExt: String) {
        let url = Bundle.main.url(forResource: name, withExtension: fileExt)!

        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }

            player.prepareToPlay()
            player.play()

        } catch let error as NSError {
            print(error.description)
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
            .drive(onNext: { [weak self] songNmae in
                guard let self = self else { return }
                guard let songNmae = songNmae else {
                    return
                }
                self.songNmae = String(songNmae.split(separator: ".").first!)
                self.fileExt = String(songNmae.split(separator: ".").last!)
            }).disposed(by: disposeBag)
        
        
        output.isPlaying
            .map { $0 ? "정지" : "시작"}
            .drive(togglePlayingButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        output.isPlaying
            .drive(onNext: { [weak self] isPlaying in
                guard let self = self,
                      let songNmae = self.songNmae,
                      let fileExt = self.fileExt else {
                    return
                }
                
                if isPlaying {
                    self.playSound(name: songNmae, fileExt: fileExt)
                } else {
                    self.stopSong()
                }
            }).disposed(by: disposeBag)
    }
}

protocol GroupPrayingVCDelegate: AnyObject {

}
