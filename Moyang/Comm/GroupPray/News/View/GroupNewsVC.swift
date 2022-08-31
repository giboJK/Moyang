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
    typealias VM = GroupNewsVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: VCDelegate?

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
        title = "소식"
        view.backgroundColor = .nightSky1
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
