//
//  MemberSelectVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MemberSelectVC: UIViewController, VCType {
    typealias VM = GroupPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?

    // MARK: - UI
    let memberTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MemberItemTableViewCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .sheep1
        $0.separatorStyle = .singleLine
        $0.rowHeight = 52
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
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
        title = "멤버 선택"
        view.backgroundColor = .sheep1
        setupMemberTableView()
    }
    private func setupMemberTableView() {
        view.addSubview(memberTableView)
        memberTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: - Binding
    func bind() {
        bindVM()
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectMember: memberTableView.rx.itemSelected.asDriver())
        let output = vm.transform(input: input)
        
        output.memberList
            .drive(memberTableView.rx
                .items(cellIdentifier: "cell", cellType: MemberItemTableViewCell.self)) { (_, item, cell) in
                    cell.nameLabel.text = item.name
                    cell.nameLabel.textColor = item.isChecked ? .ydGreen1 : .nightSky1
                    cell.checkedView.isHidden = !item.isChecked
                }.disposed(by: disposeBag)
        
        output.selectedMember
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
