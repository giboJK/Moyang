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
        .lightContent
    }
    func setupUI() {
        title = "기도목록"
        view.backgroundColor = .nightSky1
        setupPrayTableView()
        setupIndicator()
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
    
    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {
        prayTableView.rx.contentOffset.asDriver()
            .throttle(.seconds(1))
            .drive(onNext: { [weak self] offset in
                guard let self = self else { return }
                let offset = self.prayTableView.contentOffset.y
                let maxOffset = self.prayTableView.contentSize.height - self.prayTableView.frame.size.height
                if maxOffset - offset <= 0 {
                    self.vm?.fetchMoreList()
                }
            }).disposed(by: disposeBag)
    }


    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let clearList = self.rx.viewDidDisappear.map { _ -> Void in () }.asDriver(onErrorJustReturn: ())
        let input = VM.Input(selectItem: prayTableView.rx.itemSelected.asDriver(),
                             clearList: clearList)
        let output = vm.transform(input: input)
        
        output.isNetworking
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isNetworking in
                if isNetworking {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
        
        Driver.combineLatest(output.userName, output.isMyList)
            .drive(onNext: { [weak self] (name, isMy) in
                guard let self = self else { return }
                if isMy {
                    self.title = "내 모든 기도"
                } else {
                    self.title = name + "의 중보기도"
                }
            }).disposed(by: disposeBag)
        
        output.itemList
            .drive(onNext: { [weak self] dataSource in
                self?.sections = dataSource.0
                self?.itemList = dataSource.1
                self?.prayTableView.reloadData()
            }).disposed(by: disposeBag)
        
        output.detailVM
            .drive(onNext: { [weak self] detailVM in
                guard let detailVM = detailVM else { return }
                self?.coordinator?.didTapPray(vm: detailVM)
            }).disposed(by: disposeBag)
    }
}

extension GroupMemberPrayListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "sectionHeader") as! MyPrayListHeaderView
        view.titleLabel.text = sections[section]

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

protocol GroupMemberPrayListVCDelegate: AnyObject {
    func didTapPray(vm: GroupMemberPrayDetailVM)
}
