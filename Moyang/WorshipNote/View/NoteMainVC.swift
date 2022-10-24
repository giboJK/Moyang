//
//  NoteMainVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/20.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NoteMainVC: UIViewController, VCType {
    typealias VM = WorshipNoteVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: NoteMainVCDelegate?

    // MARK: - UI
    let headerHeight: CGFloat = 44
    let minHeaderHeight: CGFloat = 44
    
    let searchBar = MoyangSearchBar().then {
        $0.isHidden = true
    }
    let headerView = WorshipNoteHeader()
    let categoryTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CategoryTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.rowHeight = 60
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let emptyNoteView = EmptyNoteView()

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
        setupNoteTableView()
        setupSearchBar()
        setupEmptyNoteView()
    }
    
    private func setupNoteTableView() {
        view.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.left.right.equalToSuperview()
        }
        categoryTableView.stickyHeader.view = headerView
        categoryTableView.stickyHeader.height = headerHeight
        categoryTableView.stickyHeader.minimumHeight = minHeaderHeight
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)).then {
            $0.backgroundColor = .clear
        }
        categoryTableView.tableFooterView = footer
    }
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.height.equalTo(36)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupEmptyNoteView() {
        view.addSubview(emptyNoteView)
        emptyNoteView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        emptyNoteView.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapEmptyView()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.categoryList.skip(1)
            .drive(categoryTableView.rx
                .items(cellIdentifier: "cell", cellType: CategoryTVCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.name
                }.disposed(by: disposeBag)
        
        output.categoryList.map { $0.isEmpty }
            .drive(onNext: { [weak self] isEmpty in
                self?.categoryTableView.isHidden = isEmpty
                self?.emptyNoteView.isHidden = !isEmpty
            }).disposed(by: disposeBag)
    }
}

protocol NoteMainVCDelegate: AnyObject {
    func didTapEmptyView()
}
