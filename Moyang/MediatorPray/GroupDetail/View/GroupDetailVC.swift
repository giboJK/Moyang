//
//  GroupDetailVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/17.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupDetailVC: UIViewController, VCType {
    typealias VM = GroupDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupDetailVCDelegate?
    
    // MARK: - Property
    let headerHeight: CGFloat = 89 + 28 + 89
    let minHeaderHeight: CGFloat = 0
    // MARK: - UI
    let moreButton = UIBarButtonItem(title: "더 보기", style: .plain, target: nil, action: nil)
    let greetingLabel = MoyangLabel().then {
        $0.text = "소개글"
        $0.textColor = .wilderness1
        $0.font = .b03
    }
    let greetingValueLabel = MoyangLabel().then {
        $0.text = "반가워요~"
        $0.textColor = .sheep1
        $0.font = .b01
        $0.numberOfLines = 2
    }
    let headerView = GroupDetailHeader()
    let memberTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MyPrayListTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 160
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let prayButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupMoreButton()
        setupGreetingLabel()
        setupGreetingValueLabel()
        setupMediatorTableView()
        setupPrayButton()
    }
    private func setupMoreButton() {
        navigationItem.rightBarButtonItem = moreButton
    }
    private func setupGreetingLabel() {
        view.addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(17)
        }
    }
    private func setupGreetingValueLabel() {
        view.addSubview(greetingValueLabel)
        greetingValueLabel.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupMediatorTableView() {
        view.addSubview(memberTableView)
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(greetingValueLabel.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(48)
        }
        memberTableView.stickyHeader.view = headerView
        memberTableView.stickyHeader.height = headerHeight
        memberTableView.stickyHeader.minimumHeight = minHeaderHeight
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 48, height: 28)).then {
            $0.backgroundColor = .clear
        }
        memberTableView.tableFooterView = footer
    }
    private func setupPrayButton() {
        view.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {
        moreButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let vm = self?.vm else { return }
                self?.coordinator?.didTapMoreButton(vm: vm)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol GroupDetailVCDelegate: AnyObject {
    func didTapMoreButton(vm: GroupDetailVM)
    func didTapNewMediatorButton()
    func didTapRequestMediatorButton()
}
