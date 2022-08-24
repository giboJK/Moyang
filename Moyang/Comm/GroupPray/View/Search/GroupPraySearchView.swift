//
//  GroupPraySearchView.swift
//  Moyang
//
//  Created by kibo on 2022/08/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GroupPraySearchView: UIView {
    typealias VM = GroupPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    let searchPrayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(SearchPrayTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .sheep1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 140
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let noResultLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다."
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
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
        backgroundColor = .sheep1
        setupSearchPrayTableView()
        setupNoResultLabel()
    }
    private func setupSearchPrayTableView() {
        addSubview(searchPrayTableView)
        searchPrayTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func setupNoResultLabel() {
        addSubview(noResultLabel)
        noResultLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func bind() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectSearched: searchPrayTableView.rx.itemSelected.asDriver())
        let output = vm.transform(input: input)
        
        output.searchPrayItemList.map { $0.isEmpty }
            .drive(searchPrayTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.searchPrayItemList.map { $0.isEmpty }.map { !$0 }
            .drive(noResultLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.searchPrayItemList
            .drive(searchPrayTableView.rx
                .items(cellIdentifier: "cell", cellType: SearchPrayTVCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.name
                    cell.dateLabel.text = item.date.isoToDateString("yyyy년 MM월 dd일")
                    cell.prayLabel.text = item.pray
                    cell.prayLabel.lineBreakMode = .byTruncatingTail
                    cell.tags = item.tags
                }.disposed(by: disposeBag)
    }
}
