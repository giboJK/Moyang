//
//  GroupPrayVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupPrayVC: UIViewController, VCType {
    typealias VM = GroupPrayVM
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.dark).then {
        $0.closeButton.isHidden = true
        $0.titleLabel.isHidden = true
        $0.backgroundColor = .clear
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
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol GroupPrayVCDelegate: AnyObject {

}
