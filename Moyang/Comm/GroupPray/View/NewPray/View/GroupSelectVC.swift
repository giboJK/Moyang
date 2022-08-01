//
//  GroupSelectVC.swift
//  Moyang
//
//  Created by kibo on 2022/08/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupSelectVC: UIViewController, VCType {
    typealias VM = AllGroupVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupSelectVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
        $0.title = "그룹 선택"
    }
    let groupTableView = UITableView().then {
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
        setupGroupTableView()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupGroupTableView() {
        view.addSubview(groupTableView)
        groupTableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(navBar.snp.bottom).offset(8)
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
        let input = VM.Input(clearList: self.rx.viewWillAppear.map { _ in () }.asDriver(onErrorJustReturn: ()),
                             selectGroup: groupTableView.rx.itemSelected.asDriver())
        let output = vm.transform(input: input)
        
        output.itemList
            .drive(groupTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupInfoTableViewCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.groupName
                }.disposed(by: disposeBag)
        
        output.groupPrayVM
            .drive(onNext: { [weak self] groupPrayVM in
                guard let groupPrayVM = groupPrayVM else { return }
                self?.coordinator?.didTapGroup(groupPrayVM: groupPrayVM)
            }).disposed(by: disposeBag)
    }
}

protocol GroupSelectVCDelegate: AnyObject {
    func didTapGroup(groupPrayVM: GroupPrayVM)
}
