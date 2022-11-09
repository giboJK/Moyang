//
//  MyPrayListVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MyPrayListVC: UIViewController, VCType {
    
    typealias VM = MyPrayListVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MyPrayListVCDelegate?

    // MARK: - Property
    var sections = [String]()
    var itemList = [[VM.PrayListItem]]()
    
    
    // MARK: - UI
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MyPrayListTVCell.self, forCellReuseIdentifier: "cell")
        $0.register(MyPrayListHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 160
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        title = "기도목록"
        view.backgroundColor = .nightSky1
        setupPrayTableView()
    }
    
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.bottom.equalToSuperview()
        }
        let footer = UIView(frame: CGRect(x: 0, y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: UIApplication.bottomInset)).then {
            $0.backgroundColor = .clear
        }
        prayTableView.tableFooterView = footer
        prayTableView.dataSource = self
        prayTableView.delegate = self
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.itemList
            .drive(onNext: { [weak self] dataSource in
                self?.sections = dataSource.0
                self?.itemList = dataSource.1
                self?.prayTableView.reloadData()
            }).disposed(by: disposeBag)
        
    }
}

extension MyPrayListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "sectionHeader") as! MyPrayListHeaderView
        view.title.text = sections[section]

        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
                MyPrayListTVCell else { return UITableViewCell() }
        let item = itemList[indexPath.section][indexPath.row]
        cell.dateLabel.text = item.latestDate.isoToDateString("yyyy. M. d.")
        cell.titleLabel.text = item.title
        cell.contentLabel.text = item.content
        cell.contentLabel.lineBreakMode = .byTruncatingTail
        return cell
    }
}

protocol MyPrayListVCDelegate: AnyObject {

}
