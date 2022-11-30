//
//  SetUserInfoVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/12.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class SetUserInfoVC: UIViewController, VCType {
    typealias VM = SignUpVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: SetUserInfoVCDelegate?
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.backButton.isHidden = true
        $0.title = "기본정보 입력"
    }
    let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
    }
    let nameTextField = UITextField().then {
        $0.backgroundColor = .sheep1
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = .nightSky1
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
        $0.defaultTextAttributes.updateValue(-0.16, forKey: .kern)
    }
    let birthLabel = UILabel().then {
        $0.text = "생일"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
    }
    let birthTextField = UITextField().then {
        $0.backgroundColor = .sheep1
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = .nightSky1
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
        $0.defaultTextAttributes.updateValue(-0.16, forKey: .kern)
    }
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date().daysAgo(365 * 10)
        return datePicker
    }()
    let confirmButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("확인", for: .normal)
    }
    let closeConfirmPopup = MoyangPopupView(style: .twoButton).then {
        $0.desc = "회원 정보를 입력하지 않으시면 회원가입이 완료되지 않습니다. 그래도 나가시겠어요?"
        $0.firstButton.setTitle("나가기", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    let failurePopup = MoyangPopupView(style: .oneButton).then {
        $0.desc = "회원 가입에 실패하였습니다"
        $0.firstButton.setTitle("확인", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupUI() {
        view.backgroundColor = .sheep2
        setupNavBar()
        setupNameLabel()
        setupNameTextField()
        setupBirthLabel()
        setupBirthTextField()
        setupConfirmButton()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(32)
        }
    }
    private func setupNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
        }
    }
    private func setupBirthLabel() {
        view.addSubview(birthLabel)
        birthLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(32)
        }
    }
    private func setupBirthTextField() {
        view.addSubview(birthTextField)
        birthTextField.snp.makeConstraints {
            $0.top.equalTo(birthLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
        }
        birthTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem.init(title: "완료", style: .done, target: self, action: #selector(datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([space, doneButton], animated: true)
        birthTextField.inputAccessoryView = toolBar
        birthTextField.inputView?.frame.size.height = 300
    }
    private func setupConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(34)
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        birthTextField.text = dateFormatter.string(from: sender.date)
    }
    @objc func datePickerDone(sender: UIDatePicker) {
        birthTextField.resignFirstResponder()
    }
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        navBar.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.closeConfirmPopup)
            }).disposed(by: disposeBag)
        
        closeConfirmPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup() {
                    self?.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
        
        closeConfirmPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        failurePopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setName: nameTextField.rx.text.asDriver(),
                             setBirth: birthTextField.rx.text.asDriver(),
                             registUser: confirmButton.rx.tap.asDriver())
        
        let output = vm.transform(input: input)
        
        output.isRegisterSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.moveToMainVC()
            }).disposed(by: disposeBag)
        
        output.isRegisterFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.failurePopup)
            }).disposed(by: disposeBag)
    }
}

protocol SetUserInfoVCDelegate: AnyObject {
    func moveToMainVC()
}
