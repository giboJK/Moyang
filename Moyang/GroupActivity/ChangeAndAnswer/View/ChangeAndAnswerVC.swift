//
//  ChangeAndAnswerVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class ChangeAndAnswerVC: UIViewController, VCType {
    typealias VM = ChangeAndAnswerVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: ChangeAndAnswerVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.dark).then {
        $0.closeButton.isHidden = true
        $0.backgroundColor = .clear
    }
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(ChangeAnswerTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 220
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit {
        Log.i(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupNavBar()
        setupPrayTextView()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupPrayTextView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(12)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.itemList
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: ChangeAnswerTVCell.self)) { (_, item, cell) in
                    cell.type = item.type
                    cell.dateLabel.text = item.date.isoToDateString()
                    cell.contentLabel.text = item.content
                    cell.setBg()
                }.disposed(by: disposeBag)
    }
}

protocol ChangeAndAnswerVCDelegate: AnyObject {

}
