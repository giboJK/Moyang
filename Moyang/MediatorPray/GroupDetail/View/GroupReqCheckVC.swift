//
//  GroupReqCheckVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupReqCheckVC: UIViewController, VCType {
    typealias VM = GroupDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?

    // MARK: - UI
    let reqLabel = MoyangLabel().then {
        $0.text = "가입 신청"
        $0.textColor = .sheep1
        $0.font = .headline
    }
    let reqTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupReqCheckTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 80
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupReqLabel()
        setupReqTableView()
        setupIndicator()
    }
    private func setupReqLabel() {
        view.addSubview(reqLabel)
        reqLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupReqTableView() {
        view.addSubview(reqTableView)
        reqTableView.snp.makeConstraints {
            $0.top.equalTo(reqLabel.snp.bottom).offset(24)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Binding
    func bind() {
        bindVM()
        bindViews()
    }
    private func bindViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.reqList
            .drive(reqTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupReqCheckTVCell.self)) { [weak self] (index, item, cell) in
                    cell.nameLabel.text = item.name
                    cell.reqDateLabel.text = item.requestDate.isoToDateString("요청일: yyyy. M. d.")
                    cell.vm = self?.vm
                    cell.index = index
                    cell.bind()
                }.disposed(by: disposeBag)
    }
}

protocol VCDelegate: AnyObject {

}
