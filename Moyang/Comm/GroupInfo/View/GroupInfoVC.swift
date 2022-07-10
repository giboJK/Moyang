//
//  GroupInfoVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/10.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupInfoVC: UIViewController, VCType {
    typealias VM = GroupInfoVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupInfoVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
        $0.title = "그룹 정보"
    }
    let startDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
        $0.text = "시작 날짜"
    }
    let startDateValueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
    }
    let pastorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
        $0.text = "담당 교역자"
    }
    let pastorNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
    }
    let divider = UIView().then {
        $0.backgroundColor = .sheep5
    }
    let memberTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupInfoTableViewCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .sheep1
        $0.separatorStyle = .none
        $0.rowHeight = 52
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
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
    func setupUI() {
        view.backgroundColor = .sheep1
        setupNavBar()
        setupStartDateLabel()
        setupStartDateValueLabel()
        setupPastorLabel()
        setupPastorNameLabel()
        setupDivider()
        setupMemberTableView()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupStartDateLabel() {
        view.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(12)
        }
    }
    private func setupStartDateValueLabel() {
        view.addSubview(startDateValueLabel)
        startDateValueLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(12)
            $0.right.equalToSuperview().inset(12)
        }
    }
    private func setupPastorLabel() {
        view.addSubview(pastorLabel)
        pastorLabel.snp.makeConstraints {
            $0.top.equalTo(startDateLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(12)
        }
    }
    private func setupPastorNameLabel() {
        view.addSubview(pastorNameLabel)
        pastorNameLabel.snp.makeConstraints {
            $0.top.equalTo(startDateLabel.snp.bottom).offset(12)
            $0.right.equalToSuperview().inset(12)
        }
    }
    private func setupDivider() {
        view.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(pastorLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    private func setupMemberTableView() {
        view.addSubview(memberTableView)
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
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
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.memberList
            .drive(memberTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupInfoTableViewCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item
                    cell.nextImageView.isHidden = true
                }.disposed(by: disposeBag)
        
        output.groupStartDate
            .drive(startDateValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.pastorInCharge
            .drive(pastorNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

protocol GroupInfoVCDelegate: AnyObject {
    func didTapGroup(groupPrayVM: GroupPrayVM)
}
