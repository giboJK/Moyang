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
    let headerHeight: CGFloat = 89 + 28 + 89 + 28
    let minHeaderHeight: CGFloat = 0
    // MARK: - UI
    let moreButton = UIBarButtonItem(title: "더 보기", style: .plain, target: nil, action: nil)
    let descLabel = MoyangLabel().then {
        $0.text = "소개글"
        $0.textColor = .wilderness1
        $0.font = .b03
    }
    let descValueLabel = MoyangLabel().then {
        $0.text = "반가워요~"
        $0.textColor = .sheep1
        $0.font = .b01
        $0.numberOfLines = 2
    }
    let headerView = GroupDetailHeader()
    let memberTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupDetailTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
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
        setupDescLabel()
        setupDescValueLabel()
        setupMediatorTableView()
        setupPrayButton()
    }
    private func setupMoreButton() {
        navigationItem.rightBarButtonItem = moreButton
    }
    private func setupDescLabel() {
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(17)
        }
    }
    private func setupDescValueLabel() {
        view.addSubview(descValueLabel)
        descValueLabel.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    private func setupMediatorTableView() {
        view.addSubview(memberTableView)
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(descValueLabel.snp.bottom).offset(28)
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
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectUser: memberTableView.rx.itemSelected.asDriver())
        let output = vm.transform(input: input)
        
        output.isNetworking
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isNetworking in
                if isNetworking {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
        
        output.groupName
            .drive(self.rx.title)
            .disposed(by: disposeBag)
        
        output.desc
            .drive(descValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.mediatorItemList
            .drive(memberTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupDetailTVCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.name
                    cell.categoryLabel.text = item.category
                    cell.latestDateLabel.text = item.date
                    cell.forwardImageView.isHidden = item.prayID.isEmpty
                }.disposed(by: disposeBag)
        
        output.listVM
            .drive(onNext: { [weak self] listVM in
                guard let listVM = listVM else { return }
                self?.coordinator?.didTapGroupMember(vm: listVM)
            }).disposed(by: disposeBag)
        
        output.exitGroupSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

protocol GroupDetailVCDelegate: AnyObject {
    func didTapMoreButton(vm: GroupDetailVM)
    func didTapNewMediatorButton()
    func didTapRequestMediatorButton()
    func didTapGroupMember(vm: GroupMemberPrayListVM)
}
