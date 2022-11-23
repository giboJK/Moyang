//
//  GroupMemberPrayListVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/23.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupMemberPrayListVC: UIViewController, VCType {
    typealias VM = GroupMemberPrayListVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupMemberPrayListVCDelegate?

    // MARK: - UI
    var sections = [String]()
    var itemList = [[VM.PrayListItem]]()
    
    
    // MARK: - UI
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MyPrayListTVCell.self, forCellReuseIdentifier: "cell")
        $0.register(MyPrayListHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 166
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
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
        setupIndicator()
    }
    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
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

protocol GroupMemberPrayListVCDelegate: AnyObject {

}
