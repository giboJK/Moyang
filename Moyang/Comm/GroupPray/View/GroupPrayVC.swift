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
    
    let headerHeight: CGFloat = 48
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
    let infoButton = UIButton().then {
        $0.setTitle("정보", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        $0.setTitleColor(.nightSky1, for: .normal)
    }
    let searchBar = MoyangSearchBar()
    
    let headerView = GroupPrayHeader()
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupPrayTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .sheep1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 220
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let autoCompleteTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(AutoCompleteTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .sheep1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 48
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
        $0.isHidden = true
    }
    let praySearchView = GroupPraySearchView().then {
        $0.isHidden = true
    }
    let addPrayButton = MoyangButton(.none).then {
        $0.setTitle("새 기도", for: .normal)
        $0.setTitleColor(.sheep1, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = .nightSky4.withAlphaComponent(0.8)
        $0.layer.cornerRadius = 16
    }
    let addChangeButton = MoyangButton(.none).then {
        $0.setTitle("변화 기록", for: .normal)
        $0.setTitleColor(.sheep1, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = .nightSky4.withAlphaComponent(0.8)
        $0.layer.cornerRadius = 16
    }
    let addAnswerButton = MoyangButton(.none).then {
        $0.setTitle("응답 기록", for: .normal)
        $0.setTitleColor(.sheep1, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = .nightSky4.withAlphaComponent(0.8)
        $0.layer.cornerRadius = 16
    }
    let prayButton = MoyangButton(.none).then {
        $0.setTitle("기도하기", for: .normal)
        $0.setTitleColor(.sheep1, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = .wilderness1.withAlphaComponent(0.8)
        $0.layer.cornerRadius = 16
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
        
        setupSearchBar()
        
        setupPrayTableView()
        setupAutoCompleteTableView()
        setupPraySearchView()
        setupAddPrayButton()
        setupAddChangeButton()
        setupAddAnswerButton()
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
    
    private func setupInfoButton() {
        navBar.addSubview(infoButton)
        infoButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
            $0.width.equalTo(32)
        }
    }
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(12)
            $0.height.equalTo(56)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupAutoCompleteTableView() {
        view.addSubview(autoCompleteTableView)
        autoCompleteTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    private func setupPraySearchView() {
        view.addSubview(praySearchView)
        praySearchView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        praySearchView.vm = vm
        praySearchView.bind()
    }
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.bottom.left.right.equalToSuperview()
        }
        prayTableView.stickyHeader.view = headerView
        prayTableView.stickyHeader.height = headerHeight
        prayTableView.stickyHeader.minimumHeight = 48
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)).then {
            $0.backgroundColor = .clear
        }
        prayTableView.tableFooterView = footer
    }
    private func setupAddPrayButton() {
        view.addSubview(addPrayButton)
        addPrayButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(64)
            $0.left.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupAddChangeButton() {
        view.addSubview(addChangeButton)
        addChangeButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(64)
            $0.left.equalTo(addPrayButton.snp.right).offset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupAddAnswerButton() {
        view.addSubview(addAnswerButton)
        addAnswerButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(64)
            $0.left.equalTo(addChangeButton.snp.right).offset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupPrayButton() {
        view.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(64)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
        
        prayButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let vm = self?.vm else { return }
                self?.coordinator?.didTapPrayButton(vm: vm)
            }).disposed(by: disposeBag)
        
        bindPrayTableView()
        
        headerView.orderButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showOrderOptionView()
            }).disposed(by: disposeBag)
        
        headerView.memberButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showMemberSelectView()
            }).disposed(by: disposeBag)
        
        searchBar.textField.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext: { [weak self] _ in
                self?.autoCompleteTableView.isHidden = false
            }).disposed(by: disposeBag)
        
        searchBar.textField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .subscribe(onNext: { [weak self] _ in
                self?.autoCompleteTableView.isHidden = true
            }).disposed(by: disposeBag)
        
        searchBar.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.praySearchView.isHidden = true
            }).disposed(by: disposeBag)
        
        autoCompleteTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.praySearchView.isHidden = false
                self?.searchBar.textField.endEditing(true)
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
    
    private func showReactionView(prayReactionDetailVM: PrayReactionDetailVM) {
        let vc = PrayReactionDetailVC()
        vc.vm = prayReactionDetailVM
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)
    }
    
    private func showReplyView(prayReplyDetailVM: PrayReplyDetailVM) {
        let vc = PrayReplyDetailVC()
        vc.vm = prayReplyDetailVM
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setKeyword: searchBar.textField.rx.text.asDriver(),
                             clearKeyword: searchBar.clearButton.rx.tap.asDriver(),
                             fetchAutocomplete: searchBar.textField.rx.controlEvent([.editingChanged]).asDriver(),
                             selectAutocomplete: autoCompleteTableView.rx.itemSelected.asDriver())
            
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.memberList
            .map({ $0.filter { !$0.id.isEmpty } })
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupPrayTVCell.self)) { [weak self] (_, item, cell) in
                    cell.userID = item.id
                    cell.nameLabel.text = item.name
                    cell.vm = self?.vm
                    cell.bind()
                }.disposed(by: disposeBag)
        
        output.autoCompleteList
            .drive(autoCompleteTableView.rx
                .items(cellIdentifier: "cell", cellType: AutoCompleteTVCell.self)) { (_, item, cell) in
                    cell.tagLabel.text = item
                }.disposed(by: disposeBag)
        
        output.order
            .drive(onNext: { [weak self] order in
                self?.headerView.orderButton.setTitle(order, for: .normal)
            }).disposed(by: disposeBag)
        
        output.selectedMember
            .map { $0.isEmpty ? "모두" : $0 }
            .drive(onNext: { [weak self] name in
                self?.headerView.memberButton.setTitle(name, for: .normal)
            }).disposed(by: disposeBag)
        
        output.prayReactionDetailVM
            .drive(onNext: { [weak self] prayReactionDetailVM in
                guard let prayReactionDetailVM = prayReactionDetailVM else { return }
                self?.showReactionView(prayReactionDetailVM: prayReactionDetailVM)
            }).disposed(by: disposeBag)
        
        output.prayReplyDetailVM
            .drive(onNext: { [weak self] prayReplyDetailVM in
                guard let prayReplyDetailVM = prayReplyDetailVM else { return }
                self?.showReplyView(prayReplyDetailVM: prayReplyDetailVM)
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
    func didTapPrayButton(vm: GroupPrayVM)
    func didTapPray(vm: GroupPrayDetailVM)
}
