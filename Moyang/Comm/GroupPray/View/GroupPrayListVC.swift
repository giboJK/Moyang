//
//  GroupPrayListVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupPrayListVC: UIViewController, VCType {
    typealias VM = GroupPrayListVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayDetailVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupPrayTableViewCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .sheep1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 220
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let prayButton = UIButton().then {
        $0.setTitle("기도하기 ", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.tintColor = .sheep1
        $0.backgroundColor = .nightSky1
        $0.layer.cornerRadius = 12
        $0.semanticContentAttribute = .forceRightToLeft
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit {
        Log.i(self)
        vm?.clearPrayList()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        setupNavBar()
        setupPrayTableView()
        setupPrayButton()
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
            $0.top.equalTo(navBar.snp.bottom).offset(12)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(8)
        }
    }
    private func setupPrayButton() {
        view.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(96)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
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
        let input = VM.Input(letsPraying: prayButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.name
            .drive(navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.prayList
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupPrayTableViewCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.name
                    cell.prayLabel.text = item.pray
                    cell.prayLabel.lineBreakMode = .byTruncatingTail
                    cell.tags = item.tags
                    cell.tagCollectionView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        cell.updateTagCollectionViewHeight()
                    }
                    cell.noTagLabel.isHidden = !item.tags.isEmpty
                }.disposed(by: disposeBag)
    }
}

protocol GroupPrayDetailVCDelegate: AnyObject {
    func didTapPraybutton(vm: GroupPrayingVM)
}
