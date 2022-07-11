//
//  TermsVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/11.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class TermsVC: UIViewController, VCType {
    typealias VM = DummyVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: TermsVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
        $0.title = "이용약관"
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
        
        let test = UILabel().then {
            $0.text = "테스트입니다"
            $0.font = .systemFont(ofSize: 20, weight: .bold)
        }
        view.addSubview(test)
        test.snp.makeConstraints {
            $0.center.equalToSuperview()
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
    }
}

protocol TermsVCDelegate: AnyObject {

}
