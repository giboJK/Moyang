//
//  GroupEventVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/28.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupEventVC: UIViewController, VCType {
    typealias VM = GroupEventVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupEventVCDelegate?
    
    // MARK: - UI
    let newsTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupEventTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 68
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
        title = "소식"
        view.backgroundColor = .nightSky1
        setupNewsTableView()
    }
    private func setupNewsTableView() {
        view.addSubview(newsTableView)
        newsTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindVM()
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectNews: newsTableView.rx.itemSelected.asDriver())
        
        let output = vm.transform(input: input)
        
        output.news
            .drive(newsTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupEventTVCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.userName
                    cell.dateLabel.text = item.date.isoToDateString("yyyy년 M월 d일 hh:mm")
                    cell.contentLabel.text = item.preview
                }.disposed(by: disposeBag)
    }
}

protocol GroupEventVCDelegate: AnyObject {

}
