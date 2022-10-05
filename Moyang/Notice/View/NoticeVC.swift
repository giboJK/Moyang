//
//  NoticeVC.swift
//  Moyang
//
//  Created by kibo on 2022/10/05.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NoticeVC: UIViewController, VCType {
    typealias VM = NoticeVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?

    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .sheep1
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .sheep2.withAlphaComponent(0.7)
    }
    let divider = UIView().then {
        $0.backgroundColor = .sheep2.withAlphaComponent(0.4)
    }
    let noticeTextView = UITextView().then {
        $0.backgroundColor = .nightSky1
        $0.layer.cornerRadius = 8
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
        $0.isEditable = false
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
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        title = "공지사항"
        view.backgroundColor = .nightSky1
        setupTitleLabel()
        setupDateLabel()
        setupDivider()
        setupNoticeTextView()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupDivider() {
        view.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(0.5)
        }
    }
    
    private func setupNoticeTextView() {
        view.addSubview(noticeTextView)
        noticeTextView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
        
        output.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.date
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.content
            .drive(noticeTextView.rx.text)
            .disposed(by: disposeBag)
    }
}
