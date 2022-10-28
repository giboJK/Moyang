//
//  MyPrayMainVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MyPrayMainVC: UIViewController, VCType {
    typealias VM = MyPrayMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MyPrayMainVCDelegate?
    
    let headerHeight: CGFloat = 44
    let minHeaderHeight: CGFloat = 44
    // MARK: - UI
    let headerView = MyPrayTableHeader()
    let searchBar = MoyangSearchBar().then {
        $0.isHidden = true
    }
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MyPrayTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 60
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
    let emptyMyPrayView = EmptyMyPrayView()

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
        view.backgroundColor = .nightSky1
        setupPrayTableView()
        setupSearchBar()
        setupPraySearchView()
        setupAutoCompleteTableView()
        setupEmptyMyPrayView()
    }
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.height.equalTo(36)
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
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
//        praySearchView.vm = vm
        praySearchView.bind()
    }
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
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
    private func setupEmptyMyPrayView() {
        view.addSubview(emptyMyPrayView)
        emptyMyPrayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        prayTableView.rx.contentOffset
            .skip(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .throttle(.milliseconds(400), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                let offset = self.prayTableView.contentOffset.y
                let maxOffset = self.prayTableView.contentSize.height - self.prayTableView.frame.size.height
                if maxOffset - offset <= 0 {
                    self.vm?.fetchPrays()
                }
            }).disposed(by: disposeBag)

        headerView.newButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapNewPray()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectPray: prayTableView.rx.itemSelected.asDriver())
        let output = vm.transform(input: input)
        
        output.myPrayList
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: MyPrayTVCell.self)) { (_, item, cell) in
                    cell.dateLabel.text = item.latestDate.isoToDateString("yyyy. M. d.")
                    cell.dayLabel.text = item.latestDate.isoToDate()?.weekDayString()
                    cell.contentLabel.text = item.pray
                    cell.contentLabel.lineBreakMode = .byTruncatingTail
                    cell.tags = item.tags
                    cell.updateUI()
                    cell.tagCollectionView.reloadData()
                }.disposed(by: disposeBag)
        
        output.myPrayList
            .map { !$0.isEmpty }
            .drive(emptyMyPrayView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.detailVM
            .drive(onNext: { [weak self] detailVM in
                guard let detailVM = detailVM else { return }
                self?.coordinator?.didTapPray(vm: detailVM)
            }).disposed(by: disposeBag)
    }
}

protocol MyPrayMainVCDelegate: AnyObject {
    func didTapNewPray()
    func didTapPray(vm: MyPrayDetailVM)
}
