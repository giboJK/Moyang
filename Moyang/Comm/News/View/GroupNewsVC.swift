//
//  GroupNewsVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/28.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupNewsVC: UIViewController, VCType {
    typealias VM = DummyVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: VCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
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
        bindVM()
    }
    private func bineViews() {

    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol GroupNewsVCDelegate: AnyObject {

}
