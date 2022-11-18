//
//  GroupSearchVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupSearchVC: UIViewController, VCType {
    typealias VM = GroupSearchVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupSearchVCDelegate?

    // MARK: - UI
    let groupTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MyPrayListTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 100
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let confirmPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .sheepPrimary, secondButtonStyle: .sheepGhost).then {
        $0.desc = "정말로 가입 요청하시겠어요?"
        $0.firstButton.setTitle("요청하기", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
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
        setupGroupTableView()
    }
    private func setupGroupTableView() {
        view.addSubview(groupTableView)
        groupTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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

protocol GroupSearchVCDelegate: AnyObject {

}
