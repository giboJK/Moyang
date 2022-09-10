//
//  GroupActivityVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupActivityVC: UIViewController, VCType {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupActivityVCDelegate?
    var groupCreateDate: Date!
    
    let headerHeight: CGFloat = 172
    let minHeaderHeight: CGFloat = 40
    
    // MARK: - UI
    let newsButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "bell", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
    }
    let addButton = UIButton().then {
        $0.setImage(Asset.Images.Pray.addItem.image.withTintColor(.sheep1), for: .normal)
        $0.tintColor = .sheep1
    }
    let searchButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
    }
    let greetingLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
        $0.textColor = .sheep2
        $0.numberOfLines = 2
    }
    let tabView = GroupActivityTabView()
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
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        
        setupNewsButton()
        setupAddButton()
        setupSearchButton()
        setupGreetingLabel()
        setupTabView()
        setupPrayTableView()
        
        setupSearchBar()
        setupPraySearchView()
        setupAutoCompleteTableView()
    }
    private func setupNewsButton() {
        view.addSubview(newsButton)
        newsButton.snp.makeConstraints {
            $0.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(24)
        }
    }
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.right.equalTo(newsButton.snp.left).offset(-16)
            $0.top.equalTo(newsButton)
            $0.size.equalTo(24)
        }
    }
    private func setupSearchButton() {
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.right.equalTo(addButton.snp.left).offset(-16)
            $0.top.equalTo(newsButton)
            $0.size.equalTo(24)
        }
        
    }
    private func setupGreetingLabel() {
        view.addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints {
            $0.top.equalTo(newsButton)
            $0.left.equalToSuperview().inset(17)
            $0.right.equalTo(searchButton.snp.left).offset(-8)
        }
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(16)
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
    private func setupTabView() {
        view.addSubview(tabView)
        tabView.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom).offset(8)
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
    
    private func showAddOptions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "새 기도", style: .default , handler: { [weak self] _ in
            guard let vm = self?.vm else { return }
            self?.coordinator?.didTapNewPrayButton(vm: vm)
        }))
        alert.addAction(UIAlertAction(title: "새 묵상", style: .default , handler: { [weak self] _ in
            guard let vm = self?.vm else { return }
            self?.coordinator?.didTapNewQTButton(vm: vm)
        }))
        
        alert.addAction(UIAlertAction(title: "한 줄 감사", style: .default , handler: { _ in
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
        }))

//        uncomment for iPad Support
        alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
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
        
//        headerView.addSharingButton.rx.tap
        addButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showAddOptions()
//                self?.coordinator?.didTapNewPrayButton(vm: vm)
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
        
//        headerView.searchButton.rx.tap
        searchButton.rx.tap
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
        
        output.greeting
            .drive(greetingLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.groupName
            .drive(headerView.groupNameLabel.rx.text)
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
        
        output.addingNewPraySuccess.skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .success, message: "기도 추가 완료", disposeBag: self.disposeBag)
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.addingNewPrayFailure.skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .failure, message: "기도 추가 중 문제가 발생하였습니다.", disposeBag: self.disposeBag)
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}

protocol GroupActivityVCDelegate: AnyObject {
    func didTapNewsButton()
    func didTapNewPrayButton(vm: GroupActivityVM)
    func didTapNewQTButton(vm: GroupActivityVM)
    func didTapPrayButton(vm: GroupActivityVM)
    func didTapPray(vm: GroupPrayDetailVM)
}
