//
//  GroupPrayVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupPrayVC: UIViewController, VCType {
    typealias VM = GroupPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayVCDelegate?
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
    let infoButton = UIButton().then {
        $0.setTitle("정보", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        $0.setTitleColor(.nightSky1, for: .normal)
    }
    lazy var groupPrayCalendar = GroupPrayCalendar(vm: self.vm)
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
    let bottomTapView = UIView().then {
        $0.backgroundColor = .sheep1
    }
    let addPrayButton = MoyangButton(.none).then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setTitle("새 기도 ", for: .normal)
        $0.setTitleColor(.nightSky1, for: .normal)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.tintColor = .nightSky1
    }
    let prayButton = MoyangButton(.none).then {
        $0.setTitle("기도하기", for: .normal)
        $0.setTitleColor(.nightSky1, for: .normal)
        $0.tintColor = .nightSky1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        self.hidesBottomBarWhenPushed = true
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupUI() {
        view.backgroundColor = .sheep1
        setupNavBar()
        setupInfoButton()
        setupBottomTapView()
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
    
    private func setupInfoButton() {
        navBar.addSubview(infoButton)
        infoButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
            $0.width.equalTo(32)
        }
    }
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.bottom.equalTo(bottomTapView.snp.top)
            $0.left.right.equalToSuperview()
        }
        prayTableView.stickyHeader.view = groupPrayCalendar
        prayTableView.stickyHeader.height = 140 + 60
        prayTableView.stickyHeader.minimumHeight = 60
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 12)).then {
            $0.backgroundColor = .clear
        }
        prayTableView.tableFooterView = footer
    }
    private func setupBottomTapView() {
        view.addSubview(bottomTapView)
        bottomTapView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(49 + UIApplication.bottomInset)
        }
        setupAddPrayButton()
        setupPrayButton()
    }
    private func setupAddPrayButton() {
        bottomTapView.addSubview(addPrayButton)
        addPrayButton.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(49)
            $0.left.equalToSuperview()
        }
    }
    private func setupPrayButton() {
        bottomTapView.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(49)
            $0.right.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    var contentOffset: CGFloat = 0
    var isAnimating = false
    let animationTime = 0.3
    
    private func bindPrayTableView() {
        prayTableView.rx.willBeginDragging
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.contentOffset = max(self.prayTableView.contentOffset.y, 0)
            }).disposed(by: disposeBag)
    }
    
    func showPrayReactionDetailVC(vm: PrayReactionDetailVM) {
        if navigationController?.topViewController is GroupPrayVC {
            let vc = PrayReactionDetailVC()
            vc.vm = vm
            present(vc, animated: true)
        }
    }
    
    func showPrayReplyDetailVC(vm: PrayReplyDetailVM) {
        if navigationController?.topViewController is GroupPrayVC {
            let vc = PrayReplyDetailVC()
            vc.vm = vm
            present(vc, animated: true)
        }
    }
    
    private func bindViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        infoButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapInfoButton()
            }).disposed(by: disposeBag)
        
        addPrayButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapNewPrayButton()
            }).disposed(by: disposeBag)
        
        bindPrayTableView()
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectMember: prayTableView.rx.itemSelected.asDriver(),
                             releaseDetailVM: self.rx.viewWillAppear.map { _ in () }.asDriver(onErrorJustReturn: ()))
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isWeek
            .skip(1)
            .drive(onNext: { [weak self] isWeek in
                if isWeek {
                    self?.prayTableView.stickyHeader.height = 140 + 60
                } else {
                    self?.prayTableView.stickyHeader.height = 232 + 60
                }
            }).disposed(by: disposeBag)
        
        output.cardPrayItemList
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupPrayTableViewCell.self)) { (index, item, cell) in
                    cell.index = index
                    cell.setupData(item: item, isPreview: true)
                }.disposed(by: disposeBag)
        
        output.detailVM
            .drive(onNext: { [weak self] detailVM in
                guard let detailVM = detailVM else { return }
                self?.coordinator?.didTapPray(vm: detailVM)
            }).disposed(by: disposeBag)
        
        output.prayReactionDetailVM
            .drive(onNext: { [weak self] prayReactionDetailVM in
                guard let prayReactionDetailVM = prayReactionDetailVM else { return }
                self?.showPrayReactionDetailVC(vm: prayReactionDetailVM)
            }).disposed(by: disposeBag)
        
        output.prayReplyDetailVM
            .drive(onNext: { [weak self] prayReplyDetailVM in
                guard let prayReplyDetailVM = prayReplyDetailVM else { return }
                self?.showPrayReplyDetailVC(vm: prayReplyDetailVM)
            }).disposed(by: disposeBag)
    }
}

protocol GroupPrayVCDelegate: AnyObject {
    func didTapInfoButton()
    func didTapNewPrayButton()
    func didTapPray(vm: GroupPrayListVM)
}
