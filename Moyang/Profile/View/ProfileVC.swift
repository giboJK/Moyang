//
//  ProfileVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/14.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class ProfileVC: UIViewController, VCType {
    typealias VM = DummyVM
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: ProfileVCDelegate?

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
        title = "내 정보"
    }

    // MARK: - Binding
    func bind() {
        bindVM()
    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol ProfileVCDelegate: AnyObject {

}
