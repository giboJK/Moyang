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
    let emailTextField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep1
        $0.layer.borderColor = .nightSky3
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 12
        $0.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [.foregroundColor : UIColor.nightSky3])
        $0.keyboardType = .emailAddress
        $0.returnKeyType = .done
    }
    let passwordTextField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep1
        $0.layer.borderColor = .nightSky3
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 12
        $0.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [.foregroundColor : UIColor.nightSky3])
        $0.returnKeyType = .done
    }
    let passwordGuideLabel = UILabel().then {
        $0.text = "비밀번호는 최소 6자 이상입니다."
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky2
    }
    let confirmationButton = MoyangButton(style: .primary).then {
        $0.setTitle("확인", for: .normal)
        $0.isEnabled = false
    }
    let emailExistPopup = MoyangPopupView(style: .oneButton).then {
        $0.title = "이미 가입된 이메일"
        $0.desc = "같은 계정으로 가입된 메일이 있습니다. 로그인해주세요"
        $0.firstButton.setTitle("확인", for: .normal)
    }
    let confirmPopup = MoyangPopupView(style: .oneButton).then {
        $0.title = "이메일 전송 성공"
        $0.desc = "이메일을 확인해주세요."
        $0.firstButton.setTitle("확인", for: .normal)
    }
    let confirmFailedPopup = MoyangPopupView(style: .oneButton).then {
        $0.title = "이메일 전송 실패"
        $0.desc = "이메일 전송에 실패하였습니다. 다시 시도해주세요."
        $0.firstButton.setTitle("확인", for: .normal)
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
