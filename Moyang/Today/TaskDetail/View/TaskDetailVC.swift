//
//  TaskDetailVC.swift
//  Moyang
//
//  Created by kibo on 2022/08/12.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class TaskDetailVC: UIViewController, VCType {
    typealias VM = TaskDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: TaskDetailVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.dark).then {
        $0.closeButton.isHidden = true
        $0.titleLabel.isHidden = true
    }
    let taskTypeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 26, weight: .semibold)
        $0.textColor = .sheep1
    }
    let timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep1
    }
    let prayButton = MoyangButton(.secondary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    let doneButton = MoyangButton(.secondary).then {
        $0.setTitle("완료", for: .normal)
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
        setupTaskTypeLabel()
        setupTimeLabel()
        setupDoneButton()
        setupPrayButton()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupTaskTypeLabel() {
        view.addSubview(taskTypeLabel)
        taskTypeLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupTimeLabel() {
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(taskTypeLabel.snp.bottom).offset(4)
            $0.left.equalTo(taskTypeLabel)
        }
    }
    private func setupDoneButton() {
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(28)
        }
    }
    private func setupPrayButton() {
        view.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(28)
            $0.bottom.equalTo(doneButton.snp.top).offset(-12)
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
        let input = VM.Input(done: doneButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.type
            .drive(taskTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.time
            .drive(onNext: { [weak self] time in
                self?.timeLabel.text = time == 0 ? "시간제한 없음" : "\(time) 분"
            }).disposed(by: disposeBag)
        
        output.isPray
            .map { !$0 }
            .drive(prayButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isDoneSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

protocol TaskDetailVCDelegate: AnyObject {

}
