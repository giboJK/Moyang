//
//  NoticeListVC.swift
//  Moyang
//
//  Created by kibo on 2022/10/05.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NoticeListVC: UIViewController, VCType {
    typealias VM = NoticeVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: NoticeListVCDelegate?

    // MARK: - UI
    let noticeTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(NoticeTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.rowHeight = 80
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        title = "공지사항"
        view.backgroundColor = .nightSky1
        setupNoticeTableView()
    }
    private func setupNoticeTableView() {
        view.addSubview(noticeTableView)
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindVM()
        bindViews()
    }
    private func bindViews() {
        noticeTableView.rx.contentOffset
            .skip(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .throttle(.milliseconds(400), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                let offset = self.noticeTableView.contentOffset.y
                let maxOffset = self.noticeTableView.contentSize.height - self.noticeTableView.frame.size.height
                if maxOffset - offset <= 0 {
                    self.vm?.fetchMoreNotices()
                }
            }).disposed(by: disposeBag)

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(showNotice: noticeTableView.rx.itemSelected.asDriver())
        let output = vm.transform(input: input)
        
        output.notices
            .drive(noticeTableView.rx
            .items(cellIdentifier: "cell", cellType: NoticeTVCell.self)) { (_, item, cell) in
                cell.titleLabel.text = item.title
                cell.dateLabel.text = item.date.isoToDateString("yyyy. M. d.")
            }.disposed(by: disposeBag)
        
        output.showNotice
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let vm = self?.vm else { return }
                self?.coordinator?.showNotice(vm: vm)
            }).disposed(by: disposeBag)
    }
}

protocol NoticeListVCDelegate: AnyObject {
    func showNotice(vm: NoticeVM)
}
