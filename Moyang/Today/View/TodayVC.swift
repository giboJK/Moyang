//
//  TodayVC.swift
//  Moyang
//
//  Created by kibo on 2022/08/10.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class TodayVC: UIViewController, VCType {
    typealias VM = TodayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: TodayVCDelegate?

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
    private func bineViews() {

    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol TodayVCDelegate: AnyObject {

}
