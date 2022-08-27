//
//  PrayReplyDetailVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/07/07.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class PrayReplyDetailVC: UIViewController, VCType {
    typealias VM = PrayReplyDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: VCDelegate?

    // MARK: - UI
    let dateSortButton = UIButton().then {
        $0.setTitle("날짜순", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = .nightSky4
        $0.layer.borderWidth = 1.0
    }
    let nameSortButton = UIButton().then {
        $0.setTitle("이름순", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = .nightSky4
        $0.layer.borderWidth = 1.0
    }
    let replyTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(ReplyTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 220
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
        title = "함께하는 기도문들"
        view.backgroundColor = .nightSky1
        setupDateSortButton()
        setupNameSortButton()
        setupReplyTableView()
    }
    private func setupDateSortButton() {
        view.addSubview(dateSortButton)
        dateSortButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(12)
            $0.height.equalTo(32)
            $0.width.equalTo(64)
        }
    }
    private func setupNameSortButton() {
        view.addSubview(nameSortButton)
        nameSortButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(dateSortButton.snp.right).offset(12)
            $0.height.equalTo(32)
            $0.width.equalTo(64)
        }
    }
    private func setupReplyTableView() {
        view.addSubview(replyTableView)
        replyTableView.snp.makeConstraints {
            $0.top.equalTo(dateSortButton.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
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
        let input = VM.Input(orderByDate: dateSortButton.rx.tap.asDriver(),
                             orderByName: nameSortButton.rx.tap.asDriver()
        )
        
        let output = vm.transform(input: input)
        
        output.itemList
            .drive(replyTableView.rx
                .items(cellIdentifier: "cell", cellType: ReplyTVCell.self)) { (index, item, cell) in
                    cell.index = index
                    cell.setupData(item: item)
                }.disposed(by: disposeBag)

        
        output.isDateSorted
            .drive(onNext: { [weak self] isDateSorted in
                guard let self = self else { return }
                if isDateSorted {
                    self.dateSortButton.setTitleColor(.sheep1, for: .normal)
                    self.nameSortButton.setTitleColor(.nightSky4, for: .normal)
                    self.dateSortButton.backgroundColor = .nightSky4
                    self.nameSortButton.backgroundColor = .sheep1
                } else {
                    self.dateSortButton.setTitleColor(.nightSky4, for: .normal)
                    self.nameSortButton.setTitleColor(.sheep1, for: .normal)
                    self.dateSortButton.backgroundColor = .sheep1
                    self.nameSortButton.backgroundColor = .nightSky4
                }
            }).disposed(by: disposeBag)
    }
}

protocol VCDelegate: AnyObject {

}
