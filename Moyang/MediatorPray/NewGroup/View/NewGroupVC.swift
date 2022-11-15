//
//  NewGroupVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/15.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NewGroupVC: UIViewController, VCType {
    typealias VM = DummyVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: NewGroupVCDelegate?

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

protocol NewGroupVCDelegate: AnyObject {

}
