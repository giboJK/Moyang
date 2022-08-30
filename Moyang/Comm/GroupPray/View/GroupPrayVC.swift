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
    let minHeaderHeight: CGFloat = 48
    
    // MARK: - UI
    let newsButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "bell", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
    }
    let groupNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 31, weight: .semibold)
        $0.textColor = .sheep1
    }
    let searchBar = MoyangSearchBar().then {
        $0.isHidden = true
    }
    
    let headerView = GroupPrayHeader()
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupPrayTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 220
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let autoCompleteTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(AutoCompleteTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        
        setupGroupNameLabel()
        setupNewsButton()
        setupPrayTableView()
        
        setupSearchBar()
        setupPraySearchView()
        setupAutoCompleteTableView()
    }
    private func setupGroupNameLabel() {
        view.addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(48)
            $0.left.equalToSuperview().inset(24)
        }
    }
    
    private func setupNewsButton() {
        view.addSubview(newsButton)
        newsButton.snp.makeConstraints {
            $0.right.equalTo(view.safeAreaLayoutGuide).inset(28)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(24)
        }
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(16)
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupAutoCompleteTableView() {
        view.addSubview(autoCompleteTableView)
        autoCompleteTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    private func setupPraySearchView() {
        view.addSubview(praySearchView)
        praySearchView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        praySearchView.vm = vm
        praySearchView.bind()
    }
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(16)
            $0.bottom.left.right.equalToSuperview()
        }
        prayTableView.stickyHeader.view = headerView
        prayTableView.stickyHeader.height = headerHeight
        prayTableView.stickyHeader.minimumHeight = minHeaderHeight
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)).then {
            $0.backgroundColor = .clear
        }
        prayTableView.tableFooterView = footer
    }
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        newsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapNewsButton()
            }).disposed(by: disposeBag)
        
        headerView.addPrayButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let vm = self?.vm else { return }
                self?.coordinator?.didTapNewPrayButton(vm: vm)
            }).disposed(by: disposeBag)
        
        headerView.prayButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let vm = self?.vm else { return }
                self?.coordinator?.didTapPrayButton(vm: vm)
            }).disposed(by: disposeBag)
        
//        headerView.orderButton.rx.tap
//            .subscribe(onNext: { [weak self] _ in
//                self?.showOrderOptionView()
//            }).disposed(by: disposeBag)
        
        headerView.searchButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.isHidden = false
                self?.prayTableView.isHidden = true
                self?.searchBar.textField.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        searchBar.textField.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext: { [weak self] _ in
                self?.autoCompleteTableView.isHidden = false
            }).disposed(by: disposeBag)
        
        searchBar.textField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .subscribe(onNext: { [weak self] _ in
                self?.autoCompleteTableView.isHidden = true
            }).disposed(by: disposeBag)
        
        // MARK: - praySearchView.isHidden
        searchBar.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.isHidden = true
                self?.praySearchView.isHidden = true
                self?.prayTableView.isHidden = false
            }).disposed(by: disposeBag)
        
        searchBar.textField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { [weak self] _ in
                self?.praySearchView.isHidden = false
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
                             searchKeyword: searchBar.textField.rx.controlEvent([.editingDidEndOnExit]).asDriver(),
                             fetchAutocomplete: searchBar.textField.rx.controlEvent([.editingChanged]).asDriver(),
                             selectAutocomplete: autoCompleteTableView.rx.itemSelected.asDriver())
            
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(groupNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.memberList
            .map({ $0.filter { !$0.id.isEmpty } })
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupPrayTVCell.self)) { [weak self] (_, item, cell) in
                    cell.userID = item.id
                    cell.nameLabel.text = item.isMe ? "내 기도" : item.name
                    cell.vm = self?.vm
                    cell.bind()
                }.disposed(by: disposeBag)
        
        output.autoCompleteList
            .drive(autoCompleteTableView.rx
                .items(cellIdentifier: "cell", cellType: AutoCompleteTVCell.self)) { (_, item, cell) in
                    cell.tagLabel.text = item
                }.disposed(by: disposeBag)
        
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
    func didTapNewsButton()
    func didTapNewPrayButton(vm: GroupPrayVM)
    func didTapPrayButton(vm: GroupPrayVM)
    func didTapPray(vm: GroupPrayDetailVM)
}
