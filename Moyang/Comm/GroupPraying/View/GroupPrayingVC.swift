//
//  GroupPrayingVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupPrayingVC: UIViewController, VCType {
    typealias VM = GroupPrayingVM
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayingVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.dark).then {
        $0.backButton.isHidden = true
        $0.titleLabel.isHidden = true
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel()
    let prevButton = UIButton()
    let nextButton = UIButton()
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupPrayingTableViewCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .sheep1
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
        view.setGradient(color1: .nightSky3, color2: .nightSky2)
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
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        navBar.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol GroupPrayingVCDelegate: AnyObject {

}
