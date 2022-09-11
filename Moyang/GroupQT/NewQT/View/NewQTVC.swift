//
//  NewQTVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/11.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NewQTVC: UIViewController, VCType {
    typealias VM = NewQTVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?

    // MARK: - UI
    let navBar = MoyangNavBar(.dark).then {
        $0.closeButton.isHidden = true
        $0.backButton.isHidden = true
        $0.title = "새 묵상"
    }
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.appleRed1, for: .normal)
    }
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.sheep2, for: .normal)
        $0.setTitleColor(.sheep4, for: .disabled)
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep2
    }
    let godCharacterLabel = UILabel().then {
        $0.text = "하나님의 성품 적기"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let godCharacterTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let myCharacterLabel = UILabel().then {
        $0.text = "나의 모습 적기"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let myCharacterTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let howToLabel = UILabel().then {
        $0.text = "삶에서의 적용점 적기"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let howToTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
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
        view.backgroundColor = .nightSky1
        setupNavBar()
        setupDateLabel()
        setupGodCharacterLabel()
        setupGodCharacterTextView()
        setupMyCharacterLabel()
        setupMyCharacterTextView()
        setupHowToLabel()
        setupHowToTextView()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(44)
        }
        setupCancelButton()
        setupSaveButton()
    }
    private func setupCancelButton() {
        navBar.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }
    private func setupSaveButton() {
        navBar.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }
    private func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(80)
        }
    }
    private func setupGodCharacterLabel() {
        view.addSubview(godCharacterLabel)
        godCharacterLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupGodCharacterTextView() {
        view.addSubview(godCharacterTextView)
        godCharacterTextView.snp.makeConstraints {
            $0.top.equalTo(godCharacterLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
    }
    private func setupMyCharacterLabel() {
        view.addSubview(myCharacterLabel)
        myCharacterLabel.snp.makeConstraints {
            $0.top.equalTo(godCharacterTextView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupMyCharacterTextView() {
        view.addSubview(myCharacterTextView)
        myCharacterTextView.snp.makeConstraints {
            $0.top.equalTo(myCharacterLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
    }
    private func setupHowToLabel() {
        view.addSubview(howToLabel)
        howToLabel.snp.makeConstraints {
            $0.top.equalTo(myCharacterTextView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupHowToTextView() {
        view.addSubview(howToTextView)
        howToTextView.snp.makeConstraints {
            $0.top.equalTo(howToLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
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
