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
