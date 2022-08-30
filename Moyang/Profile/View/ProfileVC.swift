//
//  ProfileVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class ProfileVC: UIViewController, VCType {
    typealias VM = ProfileVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: ProfileVCDelegate?

    // MARK: - UI
    let nameLabel = UILabel().then {
        $0.textColor = .sheep1
    }
    let logoutButton = MoyangButton(.none).then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.sheep1, for: .normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupLogoutButton()
    }
    // MARK: - Binding
    func bind() {
        bindVM()
        bineViews()
    }
    private func setupLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bineViews() {
        logoutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                UserData.shared.email = nil
                UserData.shared.password = nil
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol ProfileVCDelegate: AnyObject {

}
