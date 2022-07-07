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
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
        $0.backButton.isHidden = true
        $0.title = "함께하는 성도들"
        $0.backButton.tintColor = .nightSky1
    }
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
        view.backgroundColor = .sheep2
        setupNavBar()
        setupDateSortButton()
        setupNameSortButton()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    private func setupDateSortButton() {
        view.addSubview(dateSortButton)
        dateSortButton.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(12)
            $0.height.equalTo(32)
            $0.width.equalTo(64)
        }
    }
    private func setupNameSortButton() {
        view.addSubview(nameSortButton)
        nameSortButton.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(8)
            $0.left.equalTo(dateSortButton.snp.right).offset(12)
            $0.height.equalTo(32)
            $0.width.equalTo(64)
        }
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(orderByDate: dateSortButton.rx.tap.asDriver(),
                             orderByName: nameSortButton.rx.tap.asDriver()
        )
        
        let output = vm.transform(input: input)
        
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
