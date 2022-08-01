//
//  QuickPrayVC.swift
//  Moyang
//
//  Created by kibo on 2022/08/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class QuickPrayVC: UIViewController, VCType {
    typealias VM = CommunityMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: QuickPrayVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.dark).then {
        $0.backButton.isHidden = true
        $0.backgroundColor = .clear
    }
    let latestPrayTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .nightSky1
        $0.isEditable = false
    }
    let prayButton = MoyangButton(.primary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    let changeOrReceiveButton = MoyangButton(.primary).then {
        $0.setTitle("변화, 응답 기록하기", for: .normal)
    }
    let newPrayButton = MoyangButton(.primary).then {
        $0.setTitle("새 기도 추가하기", for: .normal)
    }
    let laterButton = MoyangButton(.none).then {
        $0.setTitle("나중에", for: .normal)
        $0.setTitleColor(.sheep1, for: .normal)
    }
    let noPrayLabel = UILabel().then {
        $0.text = "아직 기도가 없네요.\n새 기도를 기록해보시겠어요?"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .sheep1
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        setupNavBar()
        setupLaterButton()
        setupNewPrayButton()
        setupChangeOrReceiveButton()
        setupPrayButton()
        setupLatestPrayTextView()
        setupNoPrayLabel()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupLaterButton() {
        view.addSubview(laterButton)
        laterButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    private func setupNewPrayButton() {
        view.addSubview(newPrayButton)
        newPrayButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(laterButton.snp.top).offset(-16)
        }
    }
    private func setupChangeOrReceiveButton() {
        view.addSubview(changeOrReceiveButton)
        changeOrReceiveButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(newPrayButton.snp.top).offset(-16)
        }
    }
    private func setupPrayButton() {
        view.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(changeOrReceiveButton.snp.top).offset(-16)
        }
    }
    private func setupLatestPrayTextView() {
        view.addSubview(latestPrayTextView)
        latestPrayTextView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalTo(navBar.snp.bottom)
            $0.bottom.equalTo(prayButton.snp.top).offset(-12)
        }
    }
    private func setupNoPrayLabel() {
        view.addSubview(noPrayLabel)
        noPrayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-24)
        }
    }

    // MARK: - Binding
    func bind() {
        bineViews()
        bindVM()
    }
    private func bineViews() {
        navBar.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        laterButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e(""); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.myPrayItem
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                if let item = item {
                    self.noPrayLabel.isHidden = true
                    self.latestPrayTextView.isHidden = false
                    self.latestPrayTextView.text = item.pray
                } else {
                    self.changeOrReceiveButton.isEnabled = false
                    self.noPrayLabel.isHidden = false
                    self.latestPrayTextView.isHidden = true
                }
            }).disposed(by: disposeBag)
    }
}

protocol QuickPrayVCDelegate: AnyObject {

}
