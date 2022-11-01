//
//  MediatorPrayMainVC.swift
//  Moyang
//
//  Created by kibo on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MediatorPrayMainVC: UIViewController, VCType {
    typealias VM = MediatorPrayMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MediatorPrayMainVCDelegate?

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
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
    }
}

protocol MediatorPrayMainVCDelegate: AnyObject {

}
