//
//  GroupQTView.swift
//  Moyang
//
//  Created by kibo on 2022/09/07.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GroupQTView: UIView {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    // MARK: - UI
    let dateLabel = UILabel().then {
        $0.text = "오늘"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .sheep2
    }
    let verseLabel = UILabel().then {
        $0.text = "오늘"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let headerView = GroupPrayHeader()
    let qtTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupPrayTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 220
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupDateLabel()
        setupVerseLabel()
        setupQtTableView()
    }
    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(16)
        }
        
    }
    private func setupVerseLabel() {
        addSubview(verseLabel)
        verseLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupQtTableView() {
        addSubview(qtTableView)
        qtTableView.snp.makeConstraints {
            $0.top.equalTo(verseLabel.snp.bottom).offset(12)
            $0.left.right.bottom.equalToSuperview()
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
        let input = VM.Input()
            
        let output = vm.transform(input: input)
        
        output.qtDate
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.bibleVerses
            .drive(verseLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
