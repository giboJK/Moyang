//
//  WorshipNoteView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class WorshipNoteView: UIView {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var delegate: WorshipNoteViewDelegate?
    
    let headerHeight: CGFloat = 44
    let minHeaderHeight: CGFloat = 44
    
    let searchBar = MoyangSearchBar().then {
        $0.isHidden = true
    }
    let headerView = WorshipNoteHeader()
    let noteTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(WorshipNoteTVCell.self, forCellReuseIdentifier: "cell")
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
    let emptyNoteView = EmptyNoteView()
    
    // MARK: - UI
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupNoteTableView()
        setupSearchBar()
        setupAutoCompleteTableView()
        setupEmptyNoteView()
    }
    
    private func setupNoteTableView() {
        addSubview(noteTableView)
        noteTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.left.right.equalToSuperview()
        }
        noteTableView.stickyHeader.view = headerView
        noteTableView.stickyHeader.height = headerHeight
        noteTableView.stickyHeader.minimumHeight = minHeaderHeight
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)).then {
            $0.backgroundColor = .clear
        }
        noteTableView.tableFooterView = footer
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
    private func setupEmptyNoteView() {
        addSubview(emptyNoteView)
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
                self?.delegate?.didTapEmptyView()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input(showBibleSelect: addVerseButton.rx.tap.asDriver())
//
//        let _ = vm.transform(input: input)
    }
}

protocol WorshipNoteViewDelegate: AnyObject {
    func didTapEmptyView()
}
