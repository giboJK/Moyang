//
//  MyPrayListVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MyPrayListVC: UIViewController, VCType {
    typealias VM = MyPrayListVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MyPrayListVCDelegate?

    // MARK: - UI

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
    }

    // MARK: - Binding
    func bind() {
        bindVM()
    }
    private func bindViews() {

    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol MyPrayListVCDelegate: AnyObject {

}

