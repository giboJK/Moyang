//
//  GroupDetailMoreVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/22.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupDetailMoreVC: UIViewController, VCType {
    typealias VM = GroupDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupDetailMoreVCDelegate?

    // MARK: - UI
    var saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    let infoLabel = MoyangLabel().then {
        $0.text = "기본정보"
        $0.textColor = .wilderness1
        $0.font = .headline
    }
    let nameLabel = MoyangLabel().then {
        $0.text = "그룹명"
        $0.textColor = .sheep3
        $0.font = .b03
    }
    let nameTextField = MoyangTextField(.sheep, "그룹명").then {
        $0.returnKeyType = .done
    }
    let descLabel = MoyangLabel().then {
        $0.text = "소개글"
        $0.textColor = .sheep3
        $0.font = .b03
    }
    let descTextField = MoyangTextField(.sheep, "소개글").then {
        $0.returnKeyType = .done
    }
    let exitButton = MoyangButton(.sheepSecondary).then {
        $0.setTitle("그룹 나가기", for: .normal)
    }
    let memberLabel = MoyangLabel().then {
        $0.text = "참여자"
        $0.textColor = .wilderness1
        $0.font = .headline
    }
    let memberTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupDetailMoreTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 60
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    
    let exitConfirmPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .warning, secondButtonStyle: .sheepGhost).then {
        $0.desc = "방장이 나가면 방이 사라집니다. 계속 하시겠어요?"
        $0.firstButton.setTitle("나가기", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    let exitFailurePopup = MoyangPopupView(style: .oneButton, firstButtonStyle: .nightPrimary).then {
        $0.desc = "그룹 나가기에 실패하였습니다. 개발자에게 문의해주세요."
        $0.firstButton.setTitle("확인", for: .normal)
    }
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
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
        title = "그룹 정보"
        view.backgroundColor = .nightSky1
        setupSaveButton()
        setupInfoLabel()
        setupNameLabel()
        setupNameTextField()
        setupDescLabel()
        setupDescTextField()
        setupExitButton()
        setupMemberLabel()
        setupMemberTableView()
        setupIndicator()
    }
    private func setupSaveButton() {
        navigationItem.rightBarButtonItem = saveButton
    }
    private func setupInfoLabel() {
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(21)
        }
    }
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(17)
        }
    }
    private func setupNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
    private func setupDescLabel() {
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupDescTextField() {
        view.addSubview(descTextField)
        descTextField.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
    private func setupExitButton() {
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints {
            $0.top.equalTo(descTextField.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    private func setupMemberLabel() {
        view.addSubview(memberLabel)
        memberLabel.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(32)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupMemberTableView() {
        view.addSubview(memberTableView)
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(memberLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {
        exitConfirmPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        exitConfirmPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        exitFailurePopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(exitGroup: exitButton.rx.tap.asDriver(),
                             exitGroupLeader: exitConfirmPopup.firstButton.rx.tap.asDriver()
        )
        let output = vm.transform(input: input)
        
        output.isNetworking
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isNetworking in
                if isNetworking {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
        
        output.isLeader.map { $0 }
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isLeader
            .drive(nameTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isLeader
            .drive(descTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.groupName
            .distinctUntilChanged()
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.desc
            .distinctUntilChanged()
            .drive(descTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.memberList
            .drive(memberTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupDetailMoreTVCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.name
                    cell.leaderLabel.isHidden = !item.isLeader
                    cell.leaderImageView.isHidden = !item.isLeader
                }.disposed(by: disposeBag)
        
        output.showExitConfirmPopup
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.exitConfirmPopup)
            }).disposed(by: disposeBag)
        
        output.exitGroupSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.exitGroupFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.exitFailurePopup)
            }).disposed(by: disposeBag)
    }
}

protocol GroupDetailMoreVCDelegate: AnyObject {

}
