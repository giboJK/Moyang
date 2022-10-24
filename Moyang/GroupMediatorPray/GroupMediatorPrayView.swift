//
//  GroupMediatorPrayView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/10.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GroupMediatorPrayView: UIView {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var delegate: GroupMediatorPrayViewDelegate?
    
    let headerHeight: CGFloat = 184
//    let headerHeight: CGFloat = 44
    let minHeaderHeight: CGFloat = 44
    var moreButtonHandler: (() -> Void)?
    
    // MARK: - UI
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
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupPrayTableView()
        
        setupSearchBar()
        setupPraySearchView()
        setupAutoCompleteTableView()
    }
    private func setupSearchBar() {
        addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.height.equalTo(36)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupAutoCompleteTableView() {
        addSubview(autoCompleteTableView)
        autoCompleteTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    private func setupPraySearchView() {
        addSubview(praySearchView)
        praySearchView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        praySearchView.vm = vm
        praySearchView.bind()
    }
    private func setupPrayTableView() {
        addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.left.right.equalToSuperview()
        }
        prayTableView.stickyHeader.view = headerView
        prayTableView.stickyHeader.height = headerHeight
        prayTableView.stickyHeader.minimumHeight = minHeaderHeight
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)).then {
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
        bindHeaderView()
        bindSearchBar()
        
        autoCompleteTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.praySearchView.isHidden = false
                self?.searchBar.textField.endEditing(true)
            }).disposed(by: disposeBag)
    }
    
    private func bindHeaderView() {
        headerView.moreButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.moreButtonHandler?()
            }).disposed(by: disposeBag)
        
        headerView.searchButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.isHidden = false
                self?.prayTableView.isHidden = true
                self?.searchBar.textField.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
//        headerView.prayContainer.rx.tapGesture().when(.ended)
//            .subscribe(onNext: { [weak self] _ in
//                self?.didTapPrayContainer()
//            }).disposed(by: disposeBag)
    }

    
    private func bindSearchBar() {
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
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
            
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(headerView.groupNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

protocol GroupMediatorPrayViewDelegate: AnyObject {
    func addNewTopic()
    func showMediatorPrayDetail()
}
