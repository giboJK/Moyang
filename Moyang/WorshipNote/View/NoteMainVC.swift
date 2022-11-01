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
    let folderTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CategoryTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.rowHeight = 60
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
        setupFolderTableView()
        setupSearchBar()
    }
    
    private func setupFolderTableView() {
        view.addSubview(folderTableView)
        folderTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.left.right.equalToSuperview()
        }
        folderTableView.stickyHeader.view = headerView
        folderTableView.stickyHeader.height = headerHeight
        folderTableView.stickyHeader.minimumHeight = minHeaderHeight
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)).then {
            $0.backgroundColor = .clear
        }
        folderTableView.tableFooterView = footer
    }
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.height.equalTo(36)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selelctFolder: folderTableView.rx.itemSelected.asDriver())
        let output = vm.transform(input: input)
        
        output.folderList.skip(1)
            .drive(folderTableView.rx
                .items(cellIdentifier: "cell", cellType: CategoryTVCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.name
                }.disposed(by: disposeBag)
        
        output.folderList.map { $0.isEmpty }
            .drive(onNext: { [weak self] isEmpty in
                self?.folderTableView.isHidden = isEmpty
            }).disposed(by: disposeBag)
    }
}

protocol NoteMainVCDelegate: AnyObject {
    func didTapEmptyView()
}
