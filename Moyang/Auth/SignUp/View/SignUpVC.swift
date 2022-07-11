//
//  SignUpVC.swift
//  Moyang
//
//  Created by kibo on 2022/07/11.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class SignUpVC: UIViewController, VCType {
    typealias VM = APISignUpVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: SignUpVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
    let checkButton = MoyangButton(.primary).then {
        $0.setTitle("오오오오", for: .normal)
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
        setupCheckButton()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupCheckButton() {
        view.addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
            $0.centerY.equalToSuperview()
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
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(checkExist: checkButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.isAlreadyExist
            .skip(1)
            .drive(onNext: { _ in
                Log.w("dasdsadalsmdlsakmdlakdm")
            }).disposed(by: disposeBag)
    }
}

protocol SignUpVCDelegate: AnyObject {

}
