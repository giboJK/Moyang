//
//  MediatorPrayMainVC.swift
//  Moyang
//
//  Created by kibo on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MediatorPrayMainVC: UIViewController, VCType {
    typealias VM = MediatorPrayMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MediatorPrayMainVCDelegate?

    // MARK: - UI
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let groupListView = GroupListView()
    
    let newGroupView = NewGroupView()
    
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
        setupScrollView()
        setupGroupListView()
        setupNewGroupView()
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(250)
        }
    }
    
    private func setupGroupListView() {
        container.addSubview(groupListView)
        groupListView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    
    private func setupNewGroupView() {
        container.addSubview(newGroupView)
        newGroupView.snp.makeConstraints {
            $0.top.equalTo(groupListView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
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
    }
}

protocol MediatorPrayMainVCDelegate: AnyObject {

}
