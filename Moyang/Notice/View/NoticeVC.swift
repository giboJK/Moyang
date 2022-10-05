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
    var coordinator: NoticeVCDelegate?

    // MARK: - UI
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .sheep2
    }
    let noticeTextView = UITextView().then {
        $0.backgroundColor = .nightSky1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep1
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
        setupDateLabel()
        setupNoticeTextView()
    }
    func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.right.equalToSuperview().inset(24)
        }
    }
    func setupNoticeTextView() {
        view.addSubview(noticeTextView)
        noticeTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
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
//        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input()
    }
}

protocol NoticeVCDelegate: AnyObject {

}
