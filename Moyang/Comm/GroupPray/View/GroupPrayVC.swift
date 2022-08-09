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
    var groupCreateDate: Date!
    
    let headerMinHeight: CGFloat = 100 + 48
    let headerMaxHeight: CGFloat = 248 + 48
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
    let infoButton = UIButton().then {
        $0.setTitle("정보", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        $0.setTitleColor(.nightSky1, for: .normal)
    }
    lazy var groupPrayCalendar = GroupPrayCalendar(vm: self.vm, groupCreateDate: self.groupCreateDate)
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
    let reactionView = ReactionPopupView().then {
        $0.isHidden = true
    }
    
    let reactionPopupViewHeight: CGFloat = 36 + 8 + 80
    var selected: Int?
    
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
        prayTableView.stickyHeader.height = headerMinHeight
        prayTableView.stickyHeader.minimumHeight = 48
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 8)).then {
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
                guard let vm = self?.vm else { return }
                self?.coordinator?.didTapNewPrayButton(vm: vm)
            }).disposed(by: disposeBag)
        
        bindPrayTableView()
        
        groupPrayCalendar.orderButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showOrderOptionView()
            }).disposed(by: disposeBag)
        
        groupPrayCalendar.memberButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showMemberSelectView()
            }).disposed(by: disposeBag)
    }
    private func showOrderOptionView() {
        let actionSheet = UIAlertController(title: nil, message: "옵션을 선택하세요", preferredStyle: .actionSheet)
        
        let latestAction = UIAlertAction(title: "최근순", style: .default, handler: { [weak self] _ in
            self?.vm?.changeOrder(.latest)
        })
        
        let oldestAction = UIAlertAction(title: "오래된순", style: .default, handler: { [weak self] _ in
            self?.vm?.changeOrder(.oldest)
        })
        
        let answeredAction = UIAlertAction(title: "응답받은 기도", style: .default, handler: { [weak self] _ in
            self?.vm?.changeOrder(.isAnswerd)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in }
        
        actionSheet.addAction(latestAction)
        actionSheet.addAction(oldestAction)
        actionSheet.addAction(answeredAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showMemberSelectView() {
        let vc = MemberSelectVC()
        vc.vm = self.vm
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)
    }
    
    private func showMemberReactionView(prayReactionDetailVM: PrayReactionDetailVM) {
        let vc = PrayReactionDetailVC()
        vc.vm = prayReactionDetailVM
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectMember: prayTableView.rx.itemSelected.asDriver())
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isWeek
            .skip(1)
            .drive(onNext: { [weak self] isWeek in
                guard let self = self else { return }
                let height = isWeek ? self.headerMinHeight : self.headerMaxHeight
                self.prayTableView.stickyHeader.height = height
            }).disposed(by: disposeBag)
        
        output.memberList
            .map({ $0.filter { !$0.id.isEmpty } })
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupPrayTableViewCell.self)) { [weak self] (_, item, cell) in
                    cell.userID = item.id
                    cell.nameLabel.text = item.name
                    cell.vm = self?.vm
                    cell.bind()
                }.disposed(by: disposeBag)
        
        output.order
            .drive(onNext: { [weak self] order in
                self?.groupPrayCalendar.orderButton.setTitle(order, for: .normal)
            }).disposed(by: disposeBag)
        
        output.selectedMember
            .map { $0.isEmpty ? "모두" : $0 }
            .drive(onNext: { [weak self] name in
                self?.groupPrayCalendar.memberButton.setTitle(name, for: .normal)
            }).disposed(by: disposeBag)
        
        output.prayReactionDetailVM
            .drive(onNext: { [weak self] prayReactionDetailVM in
                guard let prayReactionDetailVM = prayReactionDetailVM else { return }
                self?.showMemberReactionView(prayReactionDetailVM: prayReactionDetailVM)
            }).disposed(by: disposeBag)
        
        output.groupPrayDetailVM
            .drive(onNext: { [weak self] groupPrayDetailVM in
                guard let groupPrayDetailVM = groupPrayDetailVM else { return }
                self?.coordinator?.didTapPray(vm: groupPrayDetailVM)
            }).disposed(by: disposeBag)
    }
}

protocol GroupPrayVCDelegate: AnyObject {
    func didTapInfoButton()
    func didTapNewPrayButton(vm: GroupPrayVM)
    func didTapPray(vm: GroupPrayDetailVM)
}
