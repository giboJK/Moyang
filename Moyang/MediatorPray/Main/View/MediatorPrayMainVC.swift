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
import RxGesture

class MediatorPrayMainVC: UIViewController, VCType {
    typealias VM = MediatorPrayMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MediatorPrayMainVCDelegate?

    // MARK: - UI
    let groupTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MyGroupTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 160
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let groupSearchView = GroupSearchView()
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
        setupGroupTableView()
        setupFooter()
    }
    
    private func setupGroupTableView() {
        view.addSubview(groupTableView)
        groupTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20 + 59 + 20 + 59)).then {
            $0.backgroundColor = .clear
        }
        footer.addSubview(groupSearchView)
        groupSearchView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(59)
        }
        footer.addSubview(newGroupView)
        newGroupView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(59)
        }
        
        groupTableView.tableFooterView = footer
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {
        newGroupView.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapNewGroupView()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.groupList
            .drive(groupTableView.rx
                .items(cellIdentifier: "cell", cellType: MyGroupTVCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.name
                    cell.greetingLabel.text = item.desc
                    cell.prayLabel.text = item.prayUser
                }.disposed(by: disposeBag)
    }
}

protocol MediatorPrayMainVCDelegate: AnyObject {
    func didTapGroup(vm: GroupDetailVM)
    func didTapNewGroupView()
}
