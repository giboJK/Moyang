//
//  MyFaithReocrdVC.swift
//  Moyang
//
//  Created by kibo on 2022/08/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MyFaithReocrdVC: UIViewController, VCType {
    typealias VM = MyFaithReocrdVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MyFaithReocrdVCDelegate?

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

protocol MyFaithReocrdVCDelegate: AnyObject {

}
