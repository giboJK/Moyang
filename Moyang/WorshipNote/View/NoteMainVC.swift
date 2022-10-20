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
