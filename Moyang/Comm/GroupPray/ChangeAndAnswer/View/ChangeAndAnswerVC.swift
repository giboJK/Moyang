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
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky2
    }
    let prayTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
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

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        setupNavBar()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }

    // MARK: - Binding
    func bind() {
        bineViews()
        bindVM()
    }
    private func bineViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol ChangeAndAnswerVCDelegate: AnyObject {

}
