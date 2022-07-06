//
//  PrayReactionDetailVC.swift
//  Moyang
//
//  Created by kibo on 2022/07/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class PrayReactionDetailVC: UIViewController, VCType {
    typealias VM = PrayReactionDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.text = "함께하는 성도들"
        $0.font = .systemFont(ofSize: 17, weight: .heavy)
        $0.textColor = .nightSky1
        $0.textAlignment = .center
        $0.backgroundColor = .sheep2
        $0.layer.cornerRadius = 17
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.layer.masksToBounds = true
    }
    let scrollView = UIScrollView()
    let container = UIView()
    let loveContainer = UIView()
    let joyContainer = UIView()
    let sadContainer = UIView()
    let prayContainer = UIView()
    
    let rowHeight: Int = 36
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        view.backgroundColor = .clear
        setupTitleLabel()
        setupScrollView()
    }
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().inset(360)
            $0.height.equalTo(24)
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.backgroundColor = .sheep2
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(250)
        }
        setupLoveContainer()
        setupJoyContainer()
        setupSadContainer()
        setupPrayContainer()
    }
    private func setupLoveContainer() {
        container.addSubview(loveContainer)
        loveContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    private func setupJoyContainer() {
        container.addSubview(joyContainer)
        joyContainer.snp.makeConstraints {
            $0.top.equalTo(loveContainer.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    private func setupSadContainer() {
        container.addSubview(sadContainer)
        sadContainer.snp.makeConstraints {
            $0.top.equalTo(joyContainer.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    private func setupPrayContainer() {
        container.addSubview(prayContainer)
        prayContainer.snp.makeConstraints {
            $0.top.equalTo(sadContainer.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        output.reactionItemList
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                if list.isEmpty { return }
                for i in 0 ..< list.count {
                    if let type = PrayReactionType(rawValue: list[i].reaction) {
                        switch type {
                        case .love:
                            self.loveContainer.snp.updateConstraints {
                                $0.height.equalTo(self.rowHeight * list[i].memberName.count)
                            }
                        case .joyful:
                            self.joyContainer.snp.updateConstraints {
                                $0.height.equalTo(self.rowHeight * list[i].memberName.count)
                            }
                        case .sad:
                            self.sadContainer.snp.updateConstraints {
                                $0.height.equalTo(self.rowHeight * list[i].memberName.count)
                            }
                        case .prayWithYou:
                            self.prayContainer.snp.updateConstraints {
                                $0.height.equalTo(self.rowHeight * list[i].memberName.count)
                            }
                        }
                        for j in 0 ..< list[i].memberName.count {
                            Log.e("")
                            let memberView = UIView()
                            let memberName = UILabel().then {
                                $0.textColor = .nightSky1
                                $0.font = .systemFont(ofSize: 14, weight: .regular)
                            }
                            let imoticonLabel = UILabel()
                            memberView.addSubview(memberName)
                            memberView.addSubview(imoticonLabel)
                            memberName.snp.makeConstraints {
                                $0.centerY.equalToSuperview()
                                $0.left.equalToSuperview().inset(20)
                            }
                            imoticonLabel.snp.makeConstraints {
                                $0.centerY.equalToSuperview()
                                $0.right.equalToSuperview().inset(20)
                            }
                            memberName.text = list[i].memberName[j]
                            imoticonLabel.text = type.desc
                            switch type {
                            case .love:
                                self.loveContainer.addSubview(memberView)
                            case .joyful:
                                self.joyContainer.addSubview(memberView)
                            case .sad:
                                self.sadContainer.addSubview(memberView)
                            case .prayWithYou:
                                self.prayContainer.addSubview(memberView)
                            }
                            memberView.snp.makeConstraints {
                                $0.top.equalToSuperview().inset(self.rowHeight * j)
                                $0.left.right.equalToSuperview()
                                $0.height.equalTo(self.rowHeight)
                            }
                        }
                    }
                }
            }).disposed(by: disposeBag)
    }
}
