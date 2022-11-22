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
        $0.register(MyPrayDetailTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 60
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
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
        .darkContent
    }
    func setupUI() {
        title = "그룹 정보"
        view.backgroundColor = .nightSky1
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
            $0.top.equalTo(exitButton.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupMemberTableView() {
        view.addSubview(memberTableView)
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(memberLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
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
        bindVM()
    }
    private func bindViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
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
    }
}

protocol GroupDetailMoreVCDelegate: AnyObject {

}
